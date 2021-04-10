FactoryBot.define do
  factory :contact_file do
    name { "MyString" }
    headers { "MyText" }
    association :user
    status { 1 }
  end
end
