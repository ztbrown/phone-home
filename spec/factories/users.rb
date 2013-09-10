FactoryGirl.define do
  factory :user do
    sequence(:email) {|n| "user#{n}@example.com" }
    password 'changeme'
    password_confirmation 'changeme'

    ignore do
      has_token true
    end

    after(:create) do |user, evaluator|
      if evaluator.has_token
        user.reset_authentication_token
        user.save
      end
    end
  end
end