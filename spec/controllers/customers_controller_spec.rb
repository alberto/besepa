require "rails_helper"

describe CustomersController do
  describe "GET index" do
    before(:each) do
      allow(controller).to receive(:get_customers)
    end

    it "has a 200 status code" do
       get :index
       expect(response).to have_http_status(:ok)
     end

    it "renders index template" do
      get :index
      expect(response).to render_template(:index)
    end

    it "assigns @customers" do
      customers = [double("customer")]
      allow(controller).to receive(:get_customers).and_return(customers)

      get :index
      expect(assigns(:customers)).to eq(customers)
    end
  end

  describe "GET new" do
    it "has a 200 status code" do
       get :new
       expect(response).to have_http_status(:ok)
     end

    it "renders new template" do
      get :new
      expect(response).to render_template(:new)
    end
  end

  describe "GET show" do
    before(:each) do
      allow(controller).to receive(:get_customer)
    end

    it "has a 200 status code" do
       get :show, id: 1
       expect(response).to have_http_status(:ok)
     end

    it "renders show template" do
      get :show, id: 1
      expect(response).to render_template(:show)
    end

    it "assigns @customer" do
      customer = double("customer")
      allow(controller).to receive(:get_customer).and_return(customer)

      get :show, id: 1
      expect(assigns(:customer)).to eq(customer)
    end

    #TODO: Error handling for nonexistent customer
  end

  describe "GET edit" do
    before(:each) do
      allow(controller).to receive(:get_customer)
    end

    it "has a 200 status code" do
       get :edit, id: 1
       expect(response).to have_http_status(:ok)
     end

    it "renders edit template" do
      get :edit, id: 1
      expect(response).to render_template(:edit)
    end

    it "assigns @customer" do
      customer = double("customer")
      allow(controller).to receive(:get_customer).and_return(customer)

      get :edit, id: 1
      expect(assigns(:customer)).to eq(customer)
    end

    #TODO: Error handling for nonexistent customer
  end

  describe "POST create" do
    let(:customer_params) { {name: "name"} }

    before(:each) do
      allow(controller).to receive(:create_customer)
    end

    it "has a 302 status code" do
       post :create, customer: customer_params
       expect(response).to have_http_status(:found)
     end

    it "redirects to index" do
      post :create, customer: customer_params
      expect(response).to redirect_to(customers_path)
    end

    it "redirects to index" do
      post :create, customer: customer_params
      expect(response).to redirect_to(customers_path)
    end

    it "displays a success message" do
      post :create, customer: customer_params
      expect(flash[:notice]).to match(/^Customer successfully created/)
    end

    #TODO: Error handling for nonexistent customer
  end

  describe "PUT update" do
    let(:customer_params) { {name: "name"} }

    before(:each) do
      allow(controller).to receive(:update_customer)
    end

    it "has a 302 status code" do
       put :update, id: 1, customer: customer_params
       expect(response).to have_http_status(:found)
     end

    it "redirects to index" do
      put :update, id: 1, customer: customer_params
      expect(response).to redirect_to(customers_path)
    end

    it "displays a success message" do
      put :update, id: 1, customer: customer_params
      expect(flash[:notice]).to match(/^Customer successfully updated/)
    end

    #TODO: Error handling for nonexistent customer
  end

  describe "DELETE destroy" do
    before(:each) do
      allow(controller).to receive(:delete_customer)
    end

    it "has a 302 status code" do
       delete :destroy, id: 1
       expect(response).to have_http_status(:found)
     end

    it "redirects to index" do
      delete :destroy, id: 1
      expect(response).to redirect_to(customers_path)
    end

    it "displays a success message" do
      delete :destroy, id: 1
      expect(flash[:notice]).to match(/^Customer successfully removed/)
    end

    #TODO: Error handling for nonexistent customer
  end
end
