require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ContactsController, type: :controller do
  describe "#index" do
    let(:user){create :user}
    subject{get :index}
    context "when not logged user" do
      it_behaves_like "not_signed_user_action"
    end

    context "when logged user" do
      before{ sign_in user }
      let(:contact){create :contact, user: user}
      it "should have a success request" do 
        subject
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "#destroy" do
    let(:user) {create :user}
    let(:contact) {create :contact, user: user}
    subject{delete :destroy, params: {id: contact.id}}

    context "when not logged user" do
      it_behaves_like "not_signed_user_action"
    end

    context "when logged user" do
      before{ sign_in user }
      before{ contact }
      it "should have a success request" do  
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to eq("Contact deleted successfully")
        expect(response).to redirect_to "http://test.host/contacts"
      end

      it "should delete one contact" do 
        expect{subject}.to change{Contact.count}.by(-1)
      end

      it "should not delete a contact from another user" do
        another_contact = create :contact
        expect{delete :destroy, params: {id: another_contact.id}}.to change{Contact.count}.by(0)
      end
    end
  end
end