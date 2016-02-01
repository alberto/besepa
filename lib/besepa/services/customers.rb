module Besepa
  module Services
    class Customers
      def initialize(rest_client)
        @rest_client = rest_client
      end

      def list
        response = @rest_client.get(collection_endpoint)
        raise_on_errors(response)
        response.body["response"].map do |customer|
          Resources::Customer.new(customer)
        end
      end

      def get(id)
        response = @rest_client.get(resource_endpoint(id))
        handle_response(response)
      end

      def create(customer)
        response = @rest_client.post("customers", {customer: customer})
        handle_response(response)
      end

      def update(customer, id)
        response = @rest_client.put(resource_endpoint(id), {customer: customer})
        handle_response(response)
      end

      def delete(id)
        response = @rest_client.delete(resource_endpoint(id))
        handle_response(response)
      end

      private
      def collection_endpoint
        "customers"
      end

      def resource_endpoint(id)
        collection_endpoint + "/#{id}"
      end

      def handle_response(response)
        raise_on_errors(response)
        Resources::Customer.new response.body["response"]
      end

      def raise_on_errors(response)
        raise Besepa::Errors::NotFoundError.new if response.status == 404
        raise Besepa::Errors::InvalidResourceError.new if response.status == 422
        raise Besepa::Errors::BesepaError.new if response.status >= 400
      end
    end
  end
end
