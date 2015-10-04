require "letssubdomain/domain"

module LetsSubdomain
  RSpec.describe Domain, :integrated do
    subject(:domain) { Domain.new(domain: "ccp-dev.com") }
    let(:subdomain) { "letssubdomain-integrated-spec" }
    let(:ips) { ["1.2.3.4", "4.3.2.1"] }

    def with_cleanup
      begin
        yield
      ensure
        domain.delete_record(name: subdomain)
      end
    end

    describe "#records" do
      it "returns all" do
        expect(domain.records.size).to be > 0

        domain.records.each do |record|
          expect(record.name).to include("ccp-dev.com")
        end
      end

      it "filtered" do
        with_cleanup do
          domain.add_record(name: subdomain, ips: ips)

          expect(
            domain.records(/#{subdomain}/).map(&:value)
          ).to eq([["1.2.3.4", "4.3.2.1"]]) # map returns an array, value is an array
        end
      end
    end

    describe "#get_record" do
      context "when record cannot be found" do
        it "returns nil" do
          expect(
            domain.get_record(name: SecureRandom.hex)
          ).to eq(nil)
        end
      end
    end

    it "#delete_record" do
      with_cleanup do
        domain.add_record(name: subdomain, ips: ips)
        expect(domain.delete_record(name: subdomain)).to eq(
          "letssubdomain-integrated-spec.ccp-dev.com was removed"
        )
      end
    end

    describe "#add_record" do
      context "when the domain zone does not exist" do
        it "raises exception" do
          expect {
            Domain.new(domain: "example.com").add_record(name: subdomain, ips: ips)
          }.to raise_error("example.com zone is not managed by this account")
        end
      end

      context "when the domain zone exists" do
        it "creates new record" do
          with_cleanup do
            expect(
              domain.add_record(name: subdomain, ips: ips)
            ).to eq(
              "letssubdomain-integrated-spec.ccp-dev.com now resolves to 1.2.3.4, 4.3.2.1"
            )
          end
        end

        context "when record already created" do
          it "does not modify it" do
            with_cleanup do
              domain.add_record(name: subdomain, ips: ips)

              expect(
                domain.add_record(name: subdomain, ips: ["2.2.2.2"])
              ).to eq("letssubdomain-integrated-spec.ccp-dev.com cannot be resolved")

              expect(
                domain.get_record(name: subdomain).value
              ).to eq(["1.2.3.4", "4.3.2.1"])
            end
          end
        end
      end
    end
  end
end
