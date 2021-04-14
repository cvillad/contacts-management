require 'rails_helper'

RSpec.describe Contact, type: :model do 
  describe "#validations" do 
    let(:contact){ build :contact }
    it "test that factory is valid" do 
      expect(contact).to be_valid
    end

    it "should validate presence of required attributes" do 
      contact = build :contact, name: "", phone: "", birth_date: "", card_number: "", email: ""
      expect(contact).not_to be_valid
      expect(contact.errors[:name]).to include("can't be blank")
      expect(contact.errors[:phone]).to include("can't be blank")
      expect(contact.errors[:birth_date]).to include("can't be blank")
      expect(contact.errors[:card_number]).to include("can't be blank")
      expect(contact.errors[:email]).to include("can't be blank")
    end
 
    it "should autogenerate card_franchise" do 
      contact.save
      expect(contact.card_franchise).to eq("Visa")
      another_contact = create :contact, card_number: "5105105105105100" #fake mastercard
      expect(another_contact.card_franchise).to eq("MasterCard")
    end

    it "has a proper last_four_digits" do 
      contact.save 
      expect(contact.card_last_four_digits).to eq("4242")
      another_contact = create :contact, card_number: "5105105105105100" #fake mastercard
      expect(another_contact.card_last_four_digits).to eq("5100")
    end

    it "has a valid name format" do 
      contact.name = "john $doe"
      expect(contact).not_to be_valid
      expect(contact.errors[:name]).to include("is invalid")
      contact.name = "john-doe"
      expect(contact).to be_valid
    end

    it "has a valid phone format" do 
      contact.phone = "12312"
      expect(contact).not_to be_valid
      contact.phone = "(+57) 300 123 4343"
      expect(contact).not_to be_valid
      contact.phone = "(+57) 300 123 43 43"
      expect(contact).to be_valid
      contact.phone = "(+57) 300-123-43-43"
      expect(contact).to be_valid
    end

    it "has a valid birth_date format" do 
      contact.birth_date = "2012-1212"
      expect(contact).not_to be_valid
      expect(contact.errors[:birth_date]).to include("is invalid")
      contact.birth_date = "201212-12"
      expect(contact).not_to be_valid 
      expect(contact.errors[:birth_date]).to include("is invalid")
      contact.birth_date = "20071119"
      expect(contact).to be_valid 
      contact.birth_date = "2007-11-19"
      expect(contact).to be_valid
    end

    it "has a valid card_number" do 
      contact.card_number = "424242424242424" #left last number
      expect(contact).not_to be_valid
      expect(contact.errors[:card_number]).to include("is invalid")
      contact.card_number = "4242424242424243" #invalid card
      expect(contact).not_to be_valid
      expect(contact.errors[:card_number]).to include("is invalid")
      contact.card_number = "4242424242424242"
      expect(contact).to be_valid
    end

    it "has a valid email format" do 
      contact.email = "example"
      expect(contact).not_to be_valid
      contact.email = "example@example.com"
      expect(contact).to be_valid
    end

    it "validates uniqueness of email" do 
      contact = create :contact
      other_contact = build :contact, email: contact.email
      expect(other_contact).not_to be_valid
      other_contact.email = "other@example.com"
      expect(other_contact).to be_valid
    end
  end

  describe ".format_birth_date" do 
    let(:contact){ build :contact }

    it "has the proper format" do 
      contact.birth_date = "2012-12-12"
      expect(contact.format_birth_date).to eq("2012 December 12")
    end
  end
end