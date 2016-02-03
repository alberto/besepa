require "feature_helper"
require "support/features/customer_support"

RSpec.feature "Customer", :type => :feature do
  let(:customer) { build_customer }
  let(:account) { build_account }
  let(:new_customer_data) { build_new_customer_data }

  scenario "lifecycle happy path" do
    customers_page = Pages::Customers.new
    customers_page.visit_page

    customers_page.create_customer customer
    expect(customers_page).to have_customer customer

    customer_page = customers_page.show_details customer
    expect(customer_page).to have_customer_details customer

    customers_page.update_customer(new_customer_data, customer)
    expect(customers_page).to have_customer_updated_with new_customer_data, customer

    customers_page.show_details customer
    customer_page.delete_customer customer
    expect(customers_page).to be_marked_as_removed customer

    customers_page.show_details customer
    customer_page.create_account account
    expect(customer_page).to have_account account
    #
    # account_page = customer_page.show_account_details account
    # expect(account_page).to have_account_details account
    #
    # account_page.replace new_account
    # customers_page.show_details customer
    # expect(customer_page).to have_account new_account
    #
    # customer_page.show_account_details new_account
    # expect(account_page).to have_account_details new_account
  end
end

def build_customer
  {
    name: Faker::Name.name,
    reference: SecureRandom.urlsafe_base64
    #NOTE: more properties here
  }
end

def build_new_customer_data
  {
    name: Faker::Name.name
  }
end

def build_account
  {
    iban: "ES4601280037590100038136"
  }
end
