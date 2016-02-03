require 'rails_helper'

describe "BankAccounts Service" do
  subject { Besepa::Client.new.accounts }

  describe "#create" do
    let(:customer_id) { 1 }

    let(:account_params) {}

    before(:each) do
      stub_request(:post, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts/).
        to_return({ body: fixture('bank_accounts/bank_account_post.json')})
    end

    it "returns a BankAccount" do
      account = subject.create(customer_id, account_params)
      expect(account).to be_a Besepa::Resources::BankAccount
    end

    it "returns the expected data" do
      account = subject.create(customer_id, account_params)
      expect(account).to have_attributes(
        id: "ban21d18575aae931777012afba1b0b8148",
        bank_name: "Banco Santander",
        bic: "BSCHESMM",
        iban: "ES7610771024203102575766",
        status: "PENDING_MANDATE",
        customer_id: "cusf11b647d2cc16e503fe8ba36f88c",
        created_at: "Sun, 10 May 2015 15:47:12 UTC +00:00"
      )
    end

    context "invalid account" do
      it "raises a InvalidResourceError" do
        stub_request(:post, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts/).
          to_return({status: 422})

        expect { subject.create(customer_id, account_params) }.to raise_error Besepa::Errors::InvalidResourceError
      end
    end
  end
end
