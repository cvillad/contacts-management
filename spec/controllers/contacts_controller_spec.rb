require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ContactsController, type: :controller do
  describe "#index" do
    subject{get :index}
    context "when not logged user" do
      it "should have a found request" do 
        subject 
        expect(response).to have_http_status(:found)
      end
    end

    context "when logged user" do
      login_user 
      it "should have a success request" do 
        subject 
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#new" do
    subject{get :new}
    context "when not logged user" do
      it "should have a found request" do 
        subject 
        expect(response).to have_http_status(:found)
      end
    end

    context "when logged user" do
      login_user 
      it "should have a success request" do 
        subject 
        expect(response).to have_http_status(:ok)
      end
    end
  end
end