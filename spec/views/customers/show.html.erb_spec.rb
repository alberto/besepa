require 'rails_helper'
require 'support/customer_support'

describe "customers/show.html.erb" do
  include CustomerHelpers

  let(:customer) { build_customer_with_id }
  it "displays all customer fields" do
    assign(:customer, customer)

    render

    expect(rendered).to have_content customer.name
    expect(rendered).to have_content customer.reference
    expect(rendered).to have_content customer.taxid
    expect(rendered).to have_content customer.status

    expect(rendered).to have_content customer.address_street
    expect(rendered).to have_content customer.address_postalcode
    expect(rendered).to have_content customer.address_city
    expect(rendered).to have_content customer.address_state
    expect(rendered).to have_content customer.address_country

    expect(rendered).to have_content customer.contact_name
    expect(rendered).to have_content customer.contact_email
    expect(rendered).to have_content customer.contact_phone
  end

  it "has edit link" do
    assign(:customer, customer)

    render

    expect(rendered).to have_link "Edit", edit_customer_path(customer.id)
  end

  it "has delete link" do
    assign(:customer, customer)

    render

    expect(rendered).to have_link "Delete", customer_path(customer.id)
  end
end
