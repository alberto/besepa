require 'faraday'
require 'faraday_middleware'

class CustomersController < ApplicationController
  def index
    key = Rails.application.secrets.besepa_api_key
    url = "https://sandbox.besepa.com/api/1/"
    @client = Faraday.new(:url => url, :headers => {:authorization => "Bearer #{key}"}) do |faraday|
      faraday.request :json
      faraday.request  :url_encoded             # form-encode POST params
      faraday.response :logger                  # log requests to STDOUT
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      faraday.response :json
    end

    response = @client.get("customers")
    @customers = response.body["response"]
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
