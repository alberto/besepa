module Besepa
  module Services
    class Customers
      def initialize(rest_client)
        @rest_client = rest_client
      end

      def list
        response = @rest_client.get("customers")
        response.body["response"].map do |customer|
          Resources::Customer.new(customer)
        end
      end

      def get(id)
        response = @rest_client.get("customers/#{id}")
        Resources::Customer.new response.body["response"]
      end

      def create(customer)
        @rest_client.post("customers", {customer: customer})
      end

      def update(customer, id)
        @rest_client.put("customers/#{id}", {customer: customer})
      end

      def delete(id)
        @rest_client.delete("customers/#{id}")
      end
    end
  end
end
