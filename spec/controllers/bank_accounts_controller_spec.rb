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


  describe "POST create" do
    let(:account_params) { {iban: "iban"} }

    before(:each) do
      allow(controller).to receive(:create_account)
    end

    it "has a 302 status code" do
       post :create, customer_id: "1", bank_account: account_params
       expect(response).to have_http_status(:found)
    end

    it "redirects to index" do
      post :create, customer_id: "1", bank_account: account_params
      expect(response).to redirect_to(customer_path(1))
    end

    it "displays a success message" do
      post :create, customer_id: "1", bank_account: account_params
      expect(flash[:notice]).to match(/^Account successfully created/)
    end

    context "with invalid data" do
      before(:each) do
        allow(controller).to receive(:create_account).and_raise(Besepa::Errors::BesepaError)
      end

      it "has a 200 status code" do
         post :create, customer_id: "1", bank_account: account_params
         expect(response).to have_http_status(:ok)
      end

      it "renders the new template" do
        post :create, customer_id: "1", bank_account: account_params
        expect(response).to render_template(:new)
      end

      it "displays an alert message" do
        post :create, customer_id: "1", bank_account: account_params
        expect(flash[:alert]).to match(/^Account could not be created/)
      end

      it "assigns updated @account" do
        post :create, customer_id: "1", bank_account: account_params

        account = assigns(:account)
        expect(account).to have_attributes(
          iban: account_params[:iban]
        )

        expect(account).not_to respond_to(:id)
      end
    end
  end

  describe "GET edit" do
    before(:each) do
      allow(controller).to receive(:get_account)
    end

    it "has a 200 status code" do
       get :edit, customer_id: "1", id: "1"
       expect(response).to have_http_status(:ok)
     end

    it "renders edit template" do
      get :edit, customer_id: "1", id: "1"
      expect(response).to render_template(:edit)
    end

    it "assigns @account" do
      account = double("account")
      allow(controller).to receive(:get_account).and_return(account)

      get :edit, customer_id: "1", id: "1"
      expect(assigns(:account)).to eq(account)
    end

    context "with nonexistent account" do
      before(:each) do
        allow(controller).to receive(:get_account).and_raise Besepa::Errors::NotFoundError
      end

      it "has a 404 status code" do
         get :edit, customer_id: "1", id: "1"
         expect(response).to have_http_status(:not_found)
       end
    end
  end

  describe "POST replace" do
    let(:account_params) { {iban: "iban"} }

    before(:each) do
      allow(controller).to receive(:replace_account)
    end

    it "has a 302 status code" do
       post :replace, customer_id: "1", id: "2", bank_account: account_params
       expect(response).to have_http_status(:found)
    end

    it "redirects to index" do
      post :replace, customer_id: "1", id: "2", bank_account: account_params
      expect(response).to redirect_to(customer_path(1))
    end

    it "displays a success message" do
      post :replace, customer_id: "1", id: "2", bank_account: account_params
      expect(flash[:notice]).to match(/^Account successfully replaced/)
    end

    context "with invalid data" do
      before(:each) do
        allow(controller).to receive(:replace_account).and_raise(Besepa::Errors::BesepaError)
      end

      it "has a 200 status code" do
         post :replace, customer_id: "1", id: "2", bank_account: account_params
         expect(response).to have_http_status(:ok)
      end

      it "renders the new template" do
        post :replace, customer_id: "1", id: "2", bank_account: account_params
        expect(response).to render_template(:edit)
      end

      it "displays an alert message" do
        post :replace, customer_id: "1", id: "2", bank_account: account_params
        expect(flash[:alert]).to match(/^Account could not be replaced/)
      end

      it "assigns updated @account" do
        post :replace, customer_id: "1", id: "2", bank_account: account_params

        account = assigns(:account)
        expect(account).to have_attributes(
          iban: account_params[:iban],
          id: "2"
        )
      end
    end
  end
end
