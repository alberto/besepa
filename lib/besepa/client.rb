module Besepa
  class Client
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

    def get_customers
      response = @rest_client.get("customers")
      response.body["response"].map do |customer|
        Resources::Customer.new(customer)
      end
    end

    def get_customer(id)
      response = @rest_client.get("customers/#{id}")
      Resources::Customer.new response.body["response"]
    end

    def create_customer(customer)
      @rest_client.post("customers", {customer: customer})
    end

    def update_customer(customer, id)
      @rest_client.put("customers/#{id}", {customer: customer})
    end

    def delete_customer(id)
      @rest_client.delete("customers/#{id}")
    end
  end
end
