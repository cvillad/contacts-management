FactoryBot.define do
  factory :contact_file do
    association :user
    status { 1 }
  end
end
