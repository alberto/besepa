require 'rails_helper'

describe "customers/new.html.erb" do

  it "renders a form to create the customer" do
    render

    expect(rendered).to have_selector("form")

    Capybara.string(rendered).find("form") do |form|
      expect(form).to have_selector("input[type='submit']")
    end
  end

  it "renders the text fields" do
    fields = [
      :name, :taxid, :reference,
      :address_street, :address_city, :address_postalcode, :address_state, :address_country,
      :contact_name, :contact_email, :contact_phone
    ]

    render

    fields.each do |field|
      expect(rendered).to have_selector("input[@name=\"customer[#{field}]\"]")
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
