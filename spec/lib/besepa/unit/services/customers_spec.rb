require 'rails_helper'

describe "Customers Service" do
  subject { Besepa::Client.new.customers }

  context "internal server error" do
    it "raises a BesepaError" do
      stub_request(:get, /.*besepa\.com\/api\/1\/customers/).
        to_return({status: 500})

      expect { subject.list }.to raise_error Besepa::Errors::BesepaError
    end
  end

  context "create invalid customer" do
    it "raises a InvalidResourceError" do
      stub_request(:post, /.*besepa\.com\/api\/1\/customers/).
        to_return({status: 422})

      expect { subject.create({}) }.to raise_error Besepa::Errors::InvalidResourceError
    end
  end

  context "get non existing customer" do
    it "raises a NotFoundError" do
      stub_request(:get, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({status: 404})

      expect { subject.get(1) }.to raise_error Besepa::Errors::NotFoundError
    end
  end

  context "delete non existing customer" do
    it "raises a NotFoundError" do
      stub_request(:delete, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({status: 404})

      expect { subject.delete(1) }.to raise_error Besepa::Errors::NotFoundError
    end
  end

  context "update non existing customer" do
    it "raises a BesepaError" do
      stub_request(:put, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({status: 500})

      expect { subject.update({name: "name"}, 1) }.to raise_error Besepa::Errors::BesepaError
    end
  end

  context "update with invalid arguments" do
    it "raises a InvalidResourceError" do
      stub_request(:put, /.*besepa\.com\/api\/1\/customers\/1/).
        to_return({status: 422})

      expect { subject.update({email: "invalid"}, 1) }.to raise_error Besepa::Errors::InvalidResourceError
    end
  end

end
