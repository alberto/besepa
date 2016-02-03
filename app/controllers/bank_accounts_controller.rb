class BankAccountsController < ApplicationController
  def new
    @customer_id = customer_id
  end

  def create
    create_account(account_params)
    redirect_to customer_path(customer_id), notice: 'Account successfully created.'
  rescue Besepa::Errors::BesepaError
    flash.now[:alert] = 'Account could not be created.'
    @account = Besepa::Resources::BankAccount::new(account_params)
    render :new
  end

  private
  def account_params
    params.require(:bank_account)
  end

  def create_account(account)
    besepa_client.accounts.create(customer_id, account)
  end

  def customer_id
    params[:customer_id]
  end

  def besepa_client
    Besepa::Client.new
  end
end
