require 'rails_helper'

RSpec.describe BankAccountsController, type: :controller do
  describe "GET new" do
    it "has a 200 status code" do
       get :new, { :customer_id => "1"  }
       expect(response).to have_http_status(:ok)
     end

    it "renders new template" do
      get :new, { :customer_id => "1"  }
      expect(response).to render_template(:new)
    end

    it "assigns @customer_id from params" do
      customer_id = "1"

      get :new, { :customer_id => customer_id  }
      expect(assigns(:customer_id)).to eq(customer_id)
    end
  end
end
