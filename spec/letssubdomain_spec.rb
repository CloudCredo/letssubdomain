require "letssubdomain"

RSpec.describe LetsSubdomain do
  subject(:app) { LetsSubdomain.new(dns_client: dns_client) }
  let(:dns_client) { double(:dns_client, resolve_dns_entry: dns_client_response) }
  let(:success) { double(:success, call: nil) }
  let(:failure) { double(:failure, call: nil) }

  describe "#reserve_subdomain" do
    before do
      app.reserve_subdomain(
        subdomain: "foo",
        domain: "example.com",
        ip: "1.1.1.1",
        success: success,
        failure: failure,
      )

      expect(dns_client).to have_received(:resolve_dns_entry).with(
        subdomain: "foo",
        domain: "example.com",
        ip: "1.1.1.1",
      )
    end

    context "when subdomain is available" do
      let(:dns_client_response) { true }

      it "succeeds with message" do
        expect(success).to have_received(:call).with(
          "foo.example.com now resolves to 1.1.1.1"
        )
      end
    end

    context "when subdomain is not available" do
      let(:dns_client_response) { false }

      it "fails with message" do
        expect(failure).to have_received(:call).with(
          "foo.example.com could not be reserved, try another subdomain"
        )
      end
    end
  end
end
