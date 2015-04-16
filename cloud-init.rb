# userdata.rb

Bundler.require(:default, :development)

require "yaml"
require "securerandom"

Cuba.use Rack::Session::Cookie, :secret => SecureRandom.base64(42)
Cuba.use Rack::Protection

Cuba.plugin Cuba::Render
Cuba.settings[:render][:template_engine] = "erb"
Cuba.settings[:render][:options][:trim] = "-"


def cli?(user_agent)
  return true if UserAgent.parse(user_agent).browser =~ /(wget)|(curl)/i
  return false
end

def pre_wrap(string)
  return "<pre>#{string}</pre>"
end

def auto_wrap(results)
  return cli?(req.user_agent) ? results + "\n" : pre_wrap(results)
end

Cuba.define do

  # load config
  @config = YAML.load_file(File.expand_path("../config/host.yml",__FILE__))

  on get do

    # /favicon.ico
    on "favicon.ico" do
      res.status = 404
      res.write "#### 404 ####"
      res.finish
    end

    # /:host
    on ":host" do |host|
      warn "serving #{host}"
      res.write auto_wrap(partial("cloud-config", @config[host.to_sym]))
    end


  end
end
