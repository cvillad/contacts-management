require 'rails_helper'
require_relative '../support/csv_manager'

RSpec.describe ContactFile, type: :model do
  describe "#validations" do 
    let(:csv_file) {CSVManager.load('spec/csv_files/valid_contacts.csv') }
    let(:contact_file) {create :contact_file, csv_file: csv_file}

    it "validate factory" do 
      expect(contact_file).to be_valid
    end

    it "should create with waiting status" do 
      expect(contact_file.status).to eq("waiting")
    end

    it "should validate presence of attributes" do
      contact_file.matched_headers = ""
      contact_file.headers = []
      contact_file.name = ""
      expect(contact_file).not_to be_valid
      expect(contact_file.errors[:matched_headers]).to include("can't be blank")
      expect(contact_file.errors[:headers]).to include("can't be blank")
      expect(contact_file.errors[:name]).to include("can't be blank")
    end

    it "should validate presence of attachable attributes" do 
      contact_file = build :contact_file
      expect(contact_file).not_to be_valid 
      expect(contact_file.errors[:csv_file]).to include("can't be blank")
    end

    it "should validate that csv_file is not empty" do 
      csv_file = CSVManager.load('spec/csv_files/empty_contacts.csv')
      contact_file = build :contact_file, csv_file: csv_file, headers: []
      
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
    context "when valid contacts provided in csv" do 
      let(:csv_file) { CSVManager.load("spec/csv_files/valid_contacts.csv") }
      let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}

      subject{contact_file.import}

      describe "if three valid contacts" do 
        it "should create 3 contacts from csv" do
          expect{subject}.to change{Contact.count}.by(3)
        end

        it "should set contact_file state to finished" do 
          subject
          expect(contact_file.finished?).to eq(true)
        end
      end

      describe "if two valid contacts contact and one invalid" do 
        let(:contact){create :contact, name: "John Doe3", email: "jdoe3@gmail.com", phone: "(+57) 322-229-52-22", card_number: "4242424242424242", birth_date: "2012-12-12", address: "Calle lagartos 75"}
        before{contact}
        it "should create two contacts" do 
          expect{subject}.to change{Contact.count}.by(2)
        end

        it "should create one failed_contact" do 
          expect{subject}.to change{FailedContact.count}.by(1)
        end

        it "should set status of contact file to finished" do 
          subject 
          expect(contact_file.finished?).to eq(true)
        end
      end
    end

    context "when file with invalid contacts" do 
      let(:csv_file) {CSVManager.load("spec/csv_files/invalid_contacts.csv") }
      let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}
      subject{contact_file.import}

      it "should create three failed contacts" do 
        expect{subject}.to change{FailedContact.count}.by(3)
      end

      it "should set status of contact file to failed" do 
        subject 
        expect(contact_file.failed?).to eq(true)
      end
    end

    context "when file with no contacts" do 
      let(:csv_file) {CSVManager.load("spec/csv_files/no_contacts.csv") }
      let(:contact_file) {create :contact_file, csv_file: csv_file, user: user}
      subject{contact_file.import}

      it "should not create failed contacts" do 
        expect{subject}.to change{FailedContact.count}.by(0)
      end

      it "should not create contacts" do 
        expect{subject}.to change{Contact.count}.by(0)
      end

      it "should set status of contact file to finished" do 
        subject 
        expect(contact_file.finished?).to eq(true)
      end
    end
  end
end
