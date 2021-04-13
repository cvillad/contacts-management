FactoryBot.define do
  factory :contact_file do
    name {"csv_file.csv"}
    headers {["full_name","email_address","cellphone","date_of birth","credit_card_number", "address"]}
    matched_headers {{"name"=> "full_name", "birth_date"=> "date_of birth", "phone"=> "cellphone", "address"=> " address", "card_number"=> "credit_card_number", "email"=> "email_address"}}
    association :user
  end
end
