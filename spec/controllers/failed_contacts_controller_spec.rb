require 'rails_helper'
require_relative '../support/devise'

RSpec.describe FailedContactsController, type: :controller do 
  context "when not logged user" do 
    describe "#index" do 
      subject {get :index}
      it_behaves_like "not_signed_user_action"
    end

    describe "#show" do 
      subject {get :show, params: {id: 1}}
      it_behaves_like "not_signed_user_action"
    end
  end

  context "when logged user" do 
    let(:user){create :user}
    before{ sign_in user }

    describe "#index" do 
      subject {get :index}
      it "should have a success response" do 
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    describe "#show" do 
      let(:failed_contact){create :failed_contact, user: user}
      context "when contact exists" do
        subject {get :show, params: { id: failed_contact }} 
        it "should have a success response" do 
          subject
          expect(response).to have_http_status(:ok)
        end
      end

      context "when contact doesn't exists for current user" do 
        let(:failed_contact_2){create :failed_contact}
        subject {get :show, params: { id: failed_contact_2}}
        it "should redirect to failed_contacts_path" do 
          subject
          expect(response).to have_http_status(:found)
          expect(flash[:alert]).to eq("You can only view your own failed contacts")
          expect(response).to redirect_to "http://test.host/failed_contacts"
        end
      end
      
    end
  end
end