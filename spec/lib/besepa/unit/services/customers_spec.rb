require 'rails_helper'

describe "Customers Service" do
  subject { Besepa::Client.new.customers }

  describe "#list" do
    before(:each) do
      stub_request(:get, /.*besepa\.com\/api\/1\/customers/).
        to_return({ body: fixture('customers/customers_get.json')})
    end

    it "returns an array of Customers" do
      customers = subject.list
      expect(customers).to be_an Array
      expect(customers.size).to eq(1)
      expect(customers.first).to be_a Besepa::Resources::Customer
    end

    it "returns the expected data" do
      customer = subject.list.first
      expect(customer).to have_attributes(
        name: "Revolucionarios S.A.",
        taxid: "A123456789",
        reference: "ez2014",
        contact_name: "Emiliano Zapata",
        contact_email: "zapata@test.com",
        contact_phone: "555101010",
        contact_language: "ES",
        address_street: "Avenida de la Revolución S/N",
        address_city: "Ali",
        address_postalcode: "01010",
        address_state: "Álava",
        address_country: "ES",
        status: "ACTIVE",
        id: "cus9878c9231d1d65a80a053684d91fa076",
        created_at: "Sun, 10 May 2015 15:47:12 UTC +00:00"
      )
    end

    context "internal server error" do
      it "raises a BesepaError" do
        stub_request(:get, /.*besepa\.com\/api\/1\/customers/).
          to_return({status: 500})

        expect { subject.list }.to raise_error Besepa::Errors::BesepaError
      end
    end
  end

  describe "#get" do
    before(:each) do
      stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({ body: fixture('customers/customer_get.json')})
    end

    it "returns a Customer" do
      customer = subject.get(1)
      expect(customer).to be_a Besepa::Resources::Customer
    end

    it "returns the expected data" do
      customer = subject.get(1)
      expect(customer).to have_attributes(
        name: "Pancho Villa SLU",
        taxid: "B98123232",
        reference: "11234",
        status: "ACTIVE",
        id: "cus32887bc363e05d1b40ba2670b11a24b2",
        created_at: "Sun, 10 May 2015 15:47:12 UTC +00:00",
      )
    end

    context "non existing customer" do
      it "raises a NotFoundError" do
        stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1/).
          to_return({status: 404})

        expect { subject.get(1) }.to raise_error Besepa::Errors::NotFoundError
      end
    end
  end

  describe "#create" do
    before(:each) do
      stub_request(:post, /.*besepa\.com\/api\/1\/customers/).
        to_return({ body: fixture('customers/customer_post.json')})
    end

    it "returns a Customer" do
      customer = subject.create({})
      expect(customer).to be_a Besepa::Resources::Customer
    end

    it "returns the expected data" do
      customer = subject.create({})
      expect(customer).to have_attributes(
        name: "Pancho Villa SLU",
        taxid: "B98123232",
        reference: "11234",
        status: "ACTIVE",
        id: "cus32887bc363e05d1b40ba2670b11a24b2",
        created_at: "Sun, 10 May 2015 15:47:12 UTC +00:00",
      )
    end

    context "invalid customer" do
      it "raises a InvalidResourceError" do
        stub_request(:post, /.*besepa\.com\/api\/1\/customers/).
          to_return({status: 422})

        expect { subject.create({}) }.to raise_error Besepa::Errors::InvalidResourceError
      end
    end
  end

  context "#update" do
    before(:each) do
      stub_request(:put, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({ body: fixture('customers/customer_put.json')})
    end

    it "returns a Customer" do
      customer = subject.update({name: "name"}, 1)
      expect(customer).to be_a Besepa::Resources::Customer
    end

    it "returns the expected data" do
      customer = subject.update({name: "name"}, 1)
      expect(customer).to have_attributes(
        name: "Pancho Villa SLU",
        taxid: "B98123232",
        reference: "11234",
        status: "ACTIVE",
        id: "cus32887bc363e05d1b40ba2670b11a24b2",
        created_at: "Sun, 10 May 2015 15:47:12 UTC +00:00",
      )
    end

    context "non existing customer" do
      it "raises a BesepaError" do
        stub_request(:put, /.*besepa\.com\/api\/1\/customers\/1/).
          to_return({status: 500})

        expect { subject.update({name: "name"}, 1) }.to raise_error Besepa::Errors::BesepaError
      end
    end

    context "with invalid arguments" do
      it "raises a InvalidResourceError" do
        stub_request(:put, /.*besepa\.com\/api\/1\/customers\/1/).
          to_return({status: 422})

        expect { subject.update({email: "invalid"}, 1) }.to raise_error Besepa::Errors::InvalidResourceError
      end
    end
  end

  context "#delete" do
    before(:each) do
      stub_request(:delete, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({ body: fixture('customers/customer_delete.json')})
    end

    it "returns a Customer" do
      customer = subject.delete(1)
      expect(customer).to be_a Besepa::Resources::Customer
    end

    it "returns the expected data" do
      customer = subject.delete(1)
      expect(customer).to have_attributes(
        name: "Pancho Villa SLU",
        taxid: "B98123232",
        reference: "11234",
        status: "ACTIVE",
        id: "cus32887bc363e05d1b40ba2670b11a24b2",
        created_at: "Sun, 10 May 2015 15:47:12 UTC +00:00",
      )
    end

    context "non existing customer" do
      it "raises a NotFoundError" do
        stub_request(:delete, /.*besepa\.com\/api\/1\/customers\/1/).
          to_return({status: 404})

        expect { subject.delete(1) }.to raise_error Besepa::Errors::NotFoundError
      end
    end
  end
end
