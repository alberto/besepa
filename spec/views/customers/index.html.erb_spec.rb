require 'rails_helper'
require 'support/customer_support'

describe "customers/index.html.erb" do
  include CustomerHelpers

  context "when there are no customers" do
    it "displays a message" do
      assign(:customers, [])

      render

      expect(rendered).to have_content "You don't have any customers yet"
    end
  end

  context "when there are customers" do
    it "displays each customer" do
      customers = 3.times.map do
        build_customer_with_id
      end
      assign(:customers, customers)

      render

      customers.each do |customer|
        expect(rendered).to have_link customer.reference, customer_path(customer.id)
        expect(rendered).to have_content customer.name
        expect(rendered).to have_content customer.address_city
        expect(rendered).to have_content customer.status
      end
    end
  end
end
