require 'rails_helper'

describe "bank_accounts/new.html.erb" do
  before { assign(:customer_id, 1) }

  it "renders a form to create the bank_account" do
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
