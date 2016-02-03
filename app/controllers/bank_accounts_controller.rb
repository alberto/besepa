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

  def edit
    @customer_id = customer_id
    @account = get_account(params[:id])
  rescue Besepa::Errors::NotFoundError
    render :text => 'Account Not Found', :status => '404'
  end

  def replace
    replace_account(account_params)
    redirect_to customer_path(customer_id), notice: 'Account successfully replaced.'
  rescue Besepa::Errors::BesepaError
    flash.now[:alert] = 'Account could not be replaced.'
    @customer_id = customer_id
    @account = Besepa::Resources::BankAccount.new(account_params.merge(id: params[:id]))
    render :edit
  end

  private
  def account_params
    params.require(:bank_account)
  end

  def create_account(account)
    besepa_client.accounts.create(customer_id, account)
  end

  def get_account(account_id)
    besepa_client.accounts.get(customer_id, account_id)
  end

  def replace_account(account)
    besepa_client.accounts.replace(customer_id, params[:id], account)
  end

  def customer_id
    params[:customer_id]
  end

  def besepa_client
    Besepa::Client.new
  end
end
