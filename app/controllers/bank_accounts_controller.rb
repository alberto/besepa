class BankAccountsController < ApplicationController
  def new
    @customer_id = params[:customer_id]
  end

  def create
  end
end
