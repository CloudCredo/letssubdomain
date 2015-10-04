require "fog/aws"

module LetsSubdomain
  class Domain
    attr_reader :connection, :domain

    def initialize(domain:, connection: default_connection)
      @connection = connection
      @domain = domain
    end

    def add_record(name:, ips:)
      if zone.records.create(name: fqdn(name), type: "A", value: ips, ttl: 300)
        return "#{fqdn(name)} now resolves to #{ips.join(", ")}"
      end
    rescue NoMethodError
      "#{fqdn(name)} cannot be modified"
    end

    def delete_record(name:)
      if record = get_record(name: name)
        return "#{fqdn(name)} was removed" if record.destroy
      end
    end

    def get_record(name:)
      zone.records.get(fqdn(name))
    end

    def records(matcher = /#{domain}/)
      zone.records.find_all { |r| r.name.index(matcher) }
    end

    private

    def zone
      @zone ||= begin
        managed_zone = connection.zones.find { |z| z.domain == "#{domain}." }
        raise "#{domain} zone is not managed by this account" unless managed_zone
        managed_zone
      end
    end

    def fqdn(name)
      [name, domain].join(".")
    end

    def default_connection
      Fog::DNS::AWS.new(
        aws_access_key_id: ENV.fetch("AWS_ACCESS_KEY_ID"),
        aws_secret_access_key: ENV.fetch("AWS_SECRET_ACCESS_KEY"),
      )
    end
  end
end
