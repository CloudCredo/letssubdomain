require "letssubdomain/dns_client"

module LetsSubdomain
  RSpec.describe DnsClient do
    subject(:client) { DnsClient.new(connection: connection) }
    let(:connection) { instance_double(Fog::DNS::AWS::Real, zones: zones) }
    let(:zones) { [double("Fog::DNS::AWS::Zone", name: "example.com.", records: records)] }
    let(:records) { instance_double(Fog::DNS::AWS::Zones, create: nil) }

    it "default connection" do
      expect(DnsClient.new.connection).to be_an_instance_of(Fog::DNS::AWS::Real)
    end

    describe "#add_record" do
      context "when the domain zone does not exist" do
        let(:zones) { [] }

        before do
          expect(records).not_to receive(:create)
        end

        it "returns false" do
          expect(
            client.add_record(subdomain: "foo", domain: "example.com", ip: "1.1.1.1")
          ).to eq(false)
        end
      end

      context "when the record can be created" do
        before do
          expect(records).to receive(:create).with(
            name: "foo.example.com",
            type: "A",
            value: "1.1.1.1"
          ).and_return(Object.new)
        end

        it "returns true" do
          expect(
            client.add_record(subdomain: "foo", domain: "example.com", ip: "1.1.1.1")
          ).to eq(true)
        end
      end

      context "when the record can not be created" do
        before do
          expect(records).to receive(:create).with(
            name: "foo.example.com",
            type: "A",
            value: "1.1.1.1"
          ).and_raise(NoMethodError)
        end

        it "returns false" do
          expect(
            client.add_record(subdomain: "foo", domain: "example.com", ip: "1.1.1.1")
          ).to eq(false)
        end
      end
    end
  end
end
