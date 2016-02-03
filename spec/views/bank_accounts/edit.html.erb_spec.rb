require 'rails_helper'
require 'support/customer_support'

describe "bank_accounts/edit.html.erb" do
  include CustomerHelpers

  before {
    assign(:customer_id, 1)
    assign(:account, build_account_with_id)
  }

  it "renders a form to replace the bank_account" do
    render

    expect(rendered).to have_selector("form")

    Capybara.string(rendered).find("form") do |form|
      expect(form).to have_selector("input[type='submit']")
    end
  end

  it "renders the text fields" do
    fields = [
      :iban
    ]

    render

    fields.each do |field|
      expect(rendered).to have_selector("input[@name=\"bank_account[#{field}]\"]")
    end
  end

  it "does not render text fields for read only properties" do
    fields = [
      :id, :status
    ]

    render

    fields.each do |field|
      expect(rendered).not_to have_selector("input[@name=\"customer[#{field}]\"]")
    end
  end
end
