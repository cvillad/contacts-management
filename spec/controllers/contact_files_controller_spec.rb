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
        subject {post :create, params: {}}
        it "should redirect to contacts_path" do 
          subject
          expect(response).to have_http_status(:found)
          expect(flash[:alert]).to eq("No file provided")
          expect(response).to redirect_to "http://test.host/contacts"
        end
      end
    end

    describe "#destroy" do 
      csv_file = create_csv_file("spec/csv_files/valid_contacts.csv")
      let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}

      subject{delete :destroy, params: { id: contact_file } }

      it "should redirect to contact_files_path" do 
        subject
        expect(response).to have_http_status(:found)
        expect(flash[:notice]).to eq("File deleted successfully")
        expect(response).to redirect_to "http://test.host/contact_files"
      end
      
    end

    describe "#match_headers" do 
      context "when valid file provided" do
        csv_file = create_csv_file("spec/csv_files/valid_contacts.csv")
        let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}
        
        subject{get :match_headers, params: { id: contact_file} }

        it "should have a succes response" do 
          subject
          expect(response).to have_http_status(:ok)
        end
      end

      context "when invalid file" do
        csv_file = create_csv_file("spec/csv_files/empty_contacts.csv")
        let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}
        
        subject{get :match_headers, params: { id: contact_file} }

        it "should have a succes response" do 
          subject
          expect(response).to have_http_status(:ok)
        end
      end
    end

    describe "#import" do 
      context "when file is valid" do
        csv_file = create_csv_file("spec/csv_files/valid_contacts.csv")
        let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}
        subject{post :import, params: { id: contact_file, name: "full_name", birth_date: "date_of birth", phone: "cellphone", address: " address", card_number: "credit_card_number", email: "email_address" }}

        it "should redirect_to contacts_path" do 
          subject 
          expect(response).to have_http_status(:found)
          #expect(flash[:notice]).to eq("Importing records from csv file...")
          expect(response).to redirect_to "http://test.host/contact_files"
        end

        it "should create 3 contacts" do 
          expect{subject}.to change{Contact.count}.by(3) 
        end
      end

      
      context "when file has some invalid contacts" do
        # full_name,email_address,cellphone,date_of birth,credit_card_number, address
        # John Doe3,jdoe3@gmail.com,(+57) 322229-52-22,2012-12-12,4242424242424242,Calle lagartos 75  invalid phone
        # John Doe4,jdoe4gmail.com,(+57) 322-272-52-25,2012-12-12,424242424242422,Calle lagartos 75   invalid email, invalid card_number
        # John Doe5,jdoe5@gmail.com,(+57) 322-221-12-62,2012-12-12,4242424242424242,Calle lagartos 75
        csv_file = create_csv_file("spec/csv_files/invalid_contacts.csv")
        let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}
        subject{post :import, params: { id: contact_file, name: "full_name", birth_date: "date_of birth", phone: "cellphone", address: " address", card_number: "credit_card_number", email: "email_address" }}

        it "should redirect_to contacts_path" do 
          subject 
          expect(response).to have_http_status(:found)
          #expect(flash[:notice]).to eq("Importing records from csv file...")
          expect(response).to redirect_to "http://test.host/contact_files"
        end

        it "should have the proper errors" do 
          subject
          expect(FailedContact.first.error_details).to include("Phone is invalid")
          expect(FailedContact.second.error_details).to include("Email is invalid")
          expect(FailedContact.second.error_details).to include("Card number is invalid")
        end

        it "should create one contact" do 
          expect{subject}.to change{Contact.count}.by(1) 
        end

        it "should create two failed_contacts" do 
          expect{subject}.to change{FailedContact.count}.by(2)
        end
      end
      
    end
  end
end