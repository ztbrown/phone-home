FactoryGirl.define do
  factory :tracker do
    sequence(:name) { |n| "Tracker #{n}" }
    active false
  end
end
