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

  def get_customers
    besepa_client.customers.list
  end

  def get_customer(id)
    besepa_client.customers.get(id)
  end

  def create_customer(customer)
    besepa_client.customers.create(customer)
  end

  def update_customer(customer, id)
    besepa_client.customers.update(customer, id)
  end

  def delete_customer(id)
    besepa_client.customers.delete(id)
  end

  def besepa_client
    Besepa::Client.new
  end
end
