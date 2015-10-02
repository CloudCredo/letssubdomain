class LetsSubdomain
  def initialize(dns_client:)
    @dns_client = dns_client
  end

  def reserve_subdomain(subdomain:, domain:, ip:, success:, failure:)
    if dns_client.resolve_dns_entry(subdomain: subdomain, domain: domain, ip: ip)
      success.call("#{subdomain}.#{domain} now resolves to #{ip}")
    else
      failure.call("#{subdomain}.#{domain} could not be reserved, try another subdomain")
    end
  end

  private

  attr_reader :dns_client
end
