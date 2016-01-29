module Besepa
  class Client
    extend Forwardable

    def_delegators :@rest_client, :get, :post, :put, :delete

    def initialize
      key = Rails.application.secrets.besepa_api_key
      url = "https://sandbox.besepa.com/api/1/"
      @rest_client = Faraday.new(:url => url, :headers => {:authorization => "Bearer #{key}"}) do |faraday|
        faraday.request :json
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.response :json
      end
    end
  end
end
