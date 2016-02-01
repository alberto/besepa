require 'rails_helper'

describe "layouts/application.html.erb" do
  it 'renders flash alerts' do
    flash[:alert] = "This is an alert!"

    render

    expect(rendered).to have_content "This is an alert!"
  end
end
