FactoryBot.define do
  factory :contact_file do
    name {"csv_file.csv"}
    headers {["full_name","email_address","cellphone","date_of birth","credit_card_number", "address"]}
    association :user
  end
end
