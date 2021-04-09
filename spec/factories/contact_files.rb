FactoryBot.define do
  factory :contact_file do
    name { "MyString" }
    headers { "MyText" }
    user { nil }
    status { 1 }
  end
end
