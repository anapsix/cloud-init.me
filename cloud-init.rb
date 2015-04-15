# userdata.rb

require "cuba"
require "cuba/render"
require "erb"
require "rack/protection"
require 'securerandom'

Cuba.use Rack::Session::Cookie, :secret => SecureRandom.base64(42)
Cuba.use Rack::Protection


Cuba.define do
  on get do

    # /
    on root do
      res.write partial("cloud-config")
    end

  end
end