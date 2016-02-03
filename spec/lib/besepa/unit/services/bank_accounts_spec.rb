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

  describe "#list" do
    before(:each) do
      stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts/).
        to_return({ body: fixture('bank_accounts/bank_accounts_get.json')})
    end

    it "returns an array of BankAccounts" do
      accounts = subject.list(1)
      expect(accounts).to be_an Array
      expect(accounts.size).to eq(1)
      expect(accounts.first).to be_a Besepa::Resources::BankAccount
    end

    it "returns the expected data" do
      account = subject.list(1).first
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

    context "internal server error" do
      it "raises a BesepaError" do
        stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts/).
          to_return({status: 500})

        expect { subject.list(1) }.to raise_error Besepa::Errors::BesepaError
      end
    end
  end

  describe "#get" do
    before(:each) do
      stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts\/1/).
        to_return({ body: fixture('bank_accounts/bank_account_get.json')})
    end

    it "returns a BankAccount" do
      account = subject.get(1, 1)
      expect(account).to be_a Besepa::Resources::BankAccount
    end

    it "returns the expected data" do
      account = subject.get(1, 1)
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

    context "non existing account" do
      it "raises a NotFoundError" do
        stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts\/1/).
          to_return({status: 404})

        expect { subject.get(1, 1) }.to raise_error Besepa::Errors::NotFoundError
      end
    end
  end

  describe "#replace" do
    let(:customer_id) { 1 }
    let(:account_id) { 2 }

    let(:account_params) {}

    before(:each) do
      stub_request(:post, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts\/2\/replace/).
        to_return({ body: fixture('bank_accounts/bank_account_replace.json')})
    end

    it "returns a BankAccount" do
      account = subject.replace(customer_id, account_id, account_params)
      expect(account).to be_a Besepa::Resources::BankAccount
    end

    it "returns the expected data" do
      account = subject.replace(customer_id, account_id, account_params)
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
        stub_request(:post, /.*besepa\.com\/api\/1\/customers\/1\/bank_accounts\/2\/replace/).
          to_return({status: 422})

        expect { subject.replace(customer_id, account_id, account_params) }.to raise_error Besepa::Errors::InvalidResourceError
      end
    end
  end
end
