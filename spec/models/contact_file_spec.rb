require 'rails_helper'

RSpec.describe ContactFile, type: :model do
  describe "#validations" do 
    file = 'spec/csv_files/valid_contacts.csv'
      csv_file = ActiveStorage::Blob.create_and_upload!(
        io: File.open(file, 'rb'),
        filename: 'valid_contacts.csv',
        content_type: 'text/csv'
      ).signed_id

      let(:contact_file) {create :contact_file, csv_file: csv_file}

    it "validate factory" do 
      expect(contact_file).to be_valid
    end

    it "should create with waiting status" do 
      expect(contact_file.status).to eq("waiting")
    end

    it "should validate presence of attributes" do 
      contact_file = build :contact_file
      expect(contact_file).not_to be_valid 
      expect(contact_file.errors[:csv_file]).to include("can't be blank")
    end

    it "should have a user" do
      contact_file = build :contact_file, user: nil
      expect(contact_file).not_to be_valid 
      expect(contact_file.errors[:user]).to include("must exist")
    end
  end

  describe ".import" do 
    let(:user) {create :user}
    context "when valid csv provided" do 
      file = Rails.root.join('spec', 'csv_files', 'valid_contacts.csv')
      it "should create contacts from csv" do 
        csv_file = ActiveStorage::Blob.create_and_upload!(
          io: File.open(file, 'rb'),
          filename: 'valid_contacts.csv',
          content_type: 'text/csv'
        )
        contact_file = create :contact_file, csv_file: csv_file, user: user
        map_headers = {name: "full_name", birth_date: "date_of birth", phone: "cellphone", address: " address", card_number: "credit_card_number", email: "email_address"}
        expect{contact_file.import(map_headers)}.to change{Contact.count}.by(3)
      end
    end

    context "when an empty csv provided" do 
      file = Rails.root.join('spec', 'csv_files', 'empty_contacts.csv')
      it "should not create any contacts contacts from csv" do 
        csv_file = ActiveStorage::Blob.create_and_upload!(
          io: File.open(file, 'rb'),
          filename: 'empty_contacts.csv',
          content_type: 'text/csv'
        ).signed_id
        contact_file = create :contact_file, csv_file: csv_file, user: user
        map_headers = {name: "full_name", birth_date: "date_of birth", phone: "cellphone", address: " address", card_number: "credit_card_number", email: "email_address"}
        expect{contact_file.import(map_headers)}.to change{Contact.count}.by(0)
      end
    end

    context "when no headers provided" do 
      file = Rails.root.join('spec', 'csv_files', 'no_headers_contacts.csv')
      it "should not create any contacts contacts from csv" do 
        csv_file = ActiveStorage::Blob.create_and_upload!(
          io: File.open(file, 'rb'),
          filename: 'no_headers_contacts.csv',
          content_type: 'text/csv'
        ).signed_id
        contact_file = create :contact_file, csv_file: csv_file, user: user
        map_headers = {name: "full_name", birth_date: "date_of birth", phone: "cellphone", address: " address", card_number: "credit_card_number", email: "email_address"}
        expect{contact_file.import(map_headers)}.to change{Contact.count}.by(0)
      end
    end
  end
end
