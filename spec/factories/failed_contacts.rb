FactoryBot.define do
  factory :failed_contact do
    name { "MyString" }
    address { "MyString" }
    email { "MyString" }
    birth_date { "MyString" }
    phone { "MyString" }
    card_number { "MyString" }
    errors { "MyText" }
  end
end
