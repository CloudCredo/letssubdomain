require "sinatra"

$LOAD_PATH.unshift("./lib", __dir__)
require "letssubdomain/domain"

use Rack::Session::Cookie, :secret => 'zi2Chie1cailoot2eovei8vaiNai9Mei6ashaezahthael3IeTheZee6xie2shae'
set :views, settings.root + "/lib/web/views"

helpers do
  def domain
    @domain ||= LetsSubdomain::Domain.new(domain: domain_name)
  end

  def ips
    ENV.fetch("IP_ADDRESSES", "1.1.1.1").split(",")
  end

  def domain_name
    ENV.fetch("DOMAIN_NAME", "cloudcredo.io")
  end

  def domain_name_scope
    ENV.fetch("DOMAIN_NAME_SCOPE", "cf-hero")
  end

  def fqdns
    domain.records(/#{domain_name_scope}.#{domain_name}/).map(&:name)
  end
end

get "/" do
  erb :index
end

post "/subdomain" do
  name = [params[:subdomain], domain_name_scope].join("-")
  session.store(:message, domain.add_record(name: name, ips: ips))
  redirect to("/")
end

run Sinatra::Application.new
