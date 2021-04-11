FactoryBot.define do
  factory :failed_contact do
    name { "John" }
    address { "Calle lagartos" }
    email { "jdoegmail.com" }
    birth_date { "20121212" }
    phone { "3002222" }
    card_number { "400123132123" }
    error_details { ["error_1", "error_2"] }
    association :user
  end
end
