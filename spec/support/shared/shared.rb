require 'rails_helper'

shared_examples_for "not_signed_user_action" do 
  it "should redirect to sign_in_path" do 
    subject 
    expect(response).to have_http_status(:found)
    expect(response).to redirect_to "http://test.host/users/sign_in"
  end
end