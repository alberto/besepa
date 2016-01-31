module CustomerHelpers
  def build_customer(overrides)
    params = {
      name: Faker::Company.name,
      taxid: SecureRandom.hex(4),
      reference: SecureRandom.urlsafe_base64,
      status: "ACTIVE",

      contact_name: Faker::Name.name,
      contact_phone: Faker::PhoneNumber.phone_number,
      contact_language: 'es',

      address_street: Faker::Address.street_address,
      address_city: Faker::Address.city,
      address_postalcode: Faker::Address.postcode,
      address_state: Faker::Address.state,
      address_country: Faker::Address.country_code
    }

    Besepa::Resources::Customer.new(params.merge(overrides))
  end

  def build_customer_with_id
    build_customer({id: SecureRandom.uuid})
  end
end
