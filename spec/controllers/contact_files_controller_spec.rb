require 'rails_helper'
require_relative '../support/devise'

RSpec.describe ContactFilesController, type: :controller do
  context "when user is not logged" do 
    describe "#index" do 
      subject{get :index}
      it_behaves_like "not_signed_user_action"
    end

    describe "#create" do 
      subject{post :create}
      it_behaves_like "not_signed_user_action"
    end

    describe "#destroy" do 
      subject{delete :destroy, params: { id: 1 } }
      it_behaves_like "not_signed_user_action"
    end

    describe "#match_headers" do 
      subject{get :match_headers, params: { id: 1 } }
      it_behaves_like "not_signed_user_action"
    end

    describe "#import" do 
      subject{post :import, params: { id: 1 }}
      it_behaves_like "not_signed_user_action"
    end
  end

  context "when user is logged" do 
    let(:user) {create :user}
    before{ sign_in user }

    describe "#index" do 
      subject{get :index}
      it "should have a success response" do 
        subject
        expect(response).to have_http_status(:ok)
      end
    end

    describe "#create" do 
      context "when valid file provided" do 
        let(:file_path) {"spec/csv_files/valid_contacts.csv"}
        let(:params) {
          {contact_file: { file: Rack::Test::UploadedFile.new(file_path, 'text/csv') } }
        }
        subject {post :create, params: params}
        it "should redirect to contact_files_path" do 
          subject 
          expect(response).to have_http_status(:found)
          expect(flash[:notice]).to eq("File uploaded successfully")
          expect(response).to redirect_to "http://test.host/contact_files"
        end

        it "should create a contact_file" do 
          expect{subject}.to change{ContactFile.count}.by(1)
        end
      end

      context "when no file provided" do 
        let(:params) {
          {}
        }
        subject {post :create, params: params}
        it "should redirect to contacts_path" do 
          subject
          expect(response).to have_http_status(:found)
          expect(flash[:alert]).to eq("No file provided")
          expect(response).to redirect_to "http://test.host/contacts"
        end
      end

      context "when invaid provided" do 
        let(:file_path) {"spec/csv_files/empty_contacts.csv"}
        let(:params) {
          {contact_file: { file: Rack::Test::UploadedFile.new(file_path, 'text/csv') } }
        }
        subject {post :create, params: params}
        it "should redirect to contacts_path" do 
          subject
          expect(response).to have_http_status(:found)
          expect(flash[:alert]).to eq("There was a problem with your file")
          expect(response).to redirect_to "http://test.host/contacts"
        end
      end
    end

    describe "#destroy" do 
      
      subject{delete :destroy, params: { id: 1 } }
      
    end

    describe "#match_headers" do 
      subject{get :match_headers, params: { id: 1 } }
      
    end

    describe "#import" do 
      subject{post :import, params: { id: 1 }}
      
    end
  end
end