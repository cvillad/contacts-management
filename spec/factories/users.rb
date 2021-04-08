FactoryBot.define do
  factory :user do
    sequence(:email){|n| "example#{n}@example.com"}
    password {"secret"}
  end
end