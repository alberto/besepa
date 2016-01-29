require 'faraday'
require 'faraday_middleware'

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
    @customer = get_customer(params[:id])
  end

  def update
    id = params[:id]
    update_customer(customer_params, id)
    redirect_to customers_path, notice: 'Cliente actualizado correctamente.'
  end

  def destroy
    id = params[:id]
    delete_customer(id)
    redirect_to customers_path, notice: 'Cliente eliminado correctamente.'
  end

  private
  def customer_params
    params.require(:customer).permit(:name, :taxid, :reference, :contact_name, :contact_email, :contact_phone, :address_street, :address_city, :address_postalcode, :address_state, :address_country)
  end

  def besepa_client
    Besepa::Client.new
  end

  def get_customers
    response = besepa_client.get("customers")
    response.body["response"].map do |customer|
      ::Besepa::Resources::Customer.new(customer)
    end
  end

  def get_customer(id)
    response = besepa_client.get("customers/#{id}")
    ::Besepa::Resources::Customer.new response.body["response"]
  end

  def create_customer(customer)
    response = besepa_client.post("customers", {customer: customer})
  end

  def update_customer(customer, id)
    response = besepa_client.put("customers/#{id}", {customer: customer})
  end

  def delete_customer(id)
    besepa_client.delete("customers/#{id}")
  end
end
