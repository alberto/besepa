module Besepa
  module Services
    class BankAccounts
      def initialize(rest_client)
        @rest_client = rest_client
      end

      def create(customer_id, account)
        response = @rest_client.post("customers/#{customer_id}/bank_accounts", {bank_account: account})
        handle_response(response)
      end

      private
      def handle_response(response)
        raise_on_errors(response)
        Resources::BankAccount.new response.body["response"]
      end

      def raise_on_errors(response)
        raise Besepa::Errors::NotFoundError.new if response.status == 404
        raise Besepa::Errors::InvalidResourceError.new if response.status == 422
        raise Besepa::Errors::BesepaError.new if response.status >= 400
      end
    end
  end
end
