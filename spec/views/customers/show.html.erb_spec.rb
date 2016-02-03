require 'rails_helper'
require 'support/customer_support'

describe "customers/show.html.erb" do
  include CustomerHelpers

  let(:customer) { build_customer_with_id }
  let(:accounts) { [build_account_with_id] }

  it "displays all customer fields" do
    assign(:customer, customer)
    assign(:accounts, [])

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

  context "when there are accounts" do
    it "displays each account" do
      assign(:customer, customer)
      assign(:accounts, accounts)

      render

      accounts.each do |account|
        expect(rendered).to have_content account.iban
        expect(rendered).to have_content account.status
        expect(rendered).to have_link "Replace", edit_customer_bank_account_path(customer.id, account.id)
      end
    end
  end

  it "has edit link" do
    assign(:customer, customer)
    assign(:accounts, accounts)

    render

    expect(rendered).to have_link "Edit", edit_customer_path(customer.id)
  end

  it "has delete link" do
    assign(:customer, customer)
    assign(:accounts, accounts)

    render

    expect(rendered).to have_link "Delete", customer_path(customer.id)
  end
end
