FactoryBot.define do
  factory :contact do
    name {"John Doe"}
    born_date {"1999-12-12"}
    phone {"(+57) 300-512-32-33"}
    address {"Calle lagartos 75"}
    card_number {"4242424242424242"}
    card_franchise {}
    sequence(:email){|n| "example#{n}@example.com"}
    association :user
  end
end