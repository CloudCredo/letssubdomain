require "fog/aws"

module LetsSubdomain
  class DnsClient
    attr_reader :connection

    def initialize(connection: default_connection)
      @connection = connection
    end

    def add_record(subdomain:, domain:, ip:)
      return false unless zone(domain)

      !!zone(domain).records.create(
        name: [subdomain, domain].join("."),
        type: "A",
        value: ip
      )
    rescue NoMethodError
      false
    end

    private

    def zone(domain_name)
      connection.zones.find { |z| z.name == "#{domain_name}." }
    end

    def default_connection
      Fog::DNS::AWS.new(
        aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID", "AWS_ACCESS_KEY_ID_NOT_SET_IN_ENV"),
        aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY", "AWS_SECRET_ACCESS_KEY_NOT_SET_IN_ENV"),
      )
    end
  end
end
