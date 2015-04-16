# userdata.rb

Bundler.require(:default, :development)

require "yaml"
require "securerandom"

Cuba.use Rack::Session::Cookie, :secret => SecureRandom.base64(42)
Cuba.use Rack::Protection


Cuba.define do
  on get do

    # /
    on root do
      config = YAML.load_file('host.yml')
      res.write partial("cloud-config", config)
    end

  end
end
