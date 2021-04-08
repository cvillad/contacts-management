FactoryBot.define do
  factory :contact do
    name {"John Doe"}
    born_date {"1999-12-12"}
    phone {"300"}
    address {}
    credit_card_number {}
    franchise {}
    sequence(:email){|n| "example#{n}@example.com"}
    association :user
  end
end