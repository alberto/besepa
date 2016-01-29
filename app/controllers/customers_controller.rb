require 'faraday'
require 'faraday_middleware'

module Besepa
  module Resources
    class Customer < OpenStruct
      def initialize(params)
        super
      end
    end
  end
end

class CustomersController < ApplicationController
  def index
    @customers = get_customers
  end

  def show
    @customer = get_customer(params[:id])
  end

  def new
  end

  def create
    create_customer(customer_params)
    redirect_to customers_path, notice: 'Cliente creado correctamente.'
  end

  def edit
    @customer = Besepa::Resources::Customer.new(get_customer(params[:id]))
  end

  def update
    id = params[:id]
    update_customer(customer_params, id)
    redirect_to customers_path, notice: 'Cliente creado correctamente.'
  end

  def destroy
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :taxid, :reference, :contact_name, :contact_email, :contact_phone, :address_street, :address_city, :address_postalcode, :address_state, :address_country)
  end

  def besepa_client
    key = Rails.application.secrets.besepa_api_key
    url = "https://sandbox.besepa.com/api/1/"
    Faraday.new(:url => url, :headers => {:authorization => "Bearer #{key}"}) do |faraday|
      faraday.request :json
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.response :json
    end
  end

  def get_customers
    response = besepa_client.get("customers")
    response.body["response"]
  end

  def get_customer(id)
    response = besepa_client.get("customers/#{id}")
    ActiveSupport::HashWithIndifferentAccess.new(response.body["response"])
  end

  def create_customer(customer)
    response = besepa_client.post("customers", {customer: customer})
  end

  def update_customer(customer, id)
    response = besepa_client.put("customers/#{id}", {customer: customer})
  end
end
