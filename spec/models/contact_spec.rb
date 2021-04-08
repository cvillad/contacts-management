require 'rails_helper'

RSpec.describe Contact, type: :model do 
  describe "#validations" do 
    let(:contact){ build :contact }
    it "test that factory is valid" do 
      expect(contact).to be_valid
    end

    it "has a valid name format" do 
      contact.name = "john $doe"
      expect(contact).not_to be_valid
      contact.name = "john-doe"
      expect(contact).to be_valid
    end

    it "has a valid email format" do 
      contact.email = "example"
      expect(contact).not_to be_valid
      contact.email = "example@example.com"
      expect(contact).to be_valid
    end

    it "havs a valid born_date format" do 
      contact.born_date = "2131-1212"
      expect(contact).not_to be_valid 
      contact.born_date = "20071119"
      expect(contact).to be_valid 
      contact.born_date = "2007-11-19"
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
end