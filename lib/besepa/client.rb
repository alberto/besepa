module Besepa
  class Client
    def initialize
      key = Rails.application.secrets.besepa_api_key
      url = "https://sandbox.besepa.com/api/1/"
      @rest_client = Faraday.new(:url => url, :headers => {:authorization => "Bearer #{key}"}) do |faraday|
        faraday.request :json
        faraday.request  :url_encoded             # form-encode POST params
        #faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
        faraday.response :json
      end
    end

    def customers
      Services::Customers.new(@rest_client)
    end

    def accounts
      Services::BankAccounts.new(@rest_client)
    end
  end
end
