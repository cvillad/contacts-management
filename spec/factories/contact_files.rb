FactoryBot.define do
  factory :contact_file do
    sequence(:name) { |n| "sample_file#{n}.csv" }
    headers { [] }
    association :user
    status { 1 }
  end
end
