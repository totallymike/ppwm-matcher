require 'factory_girl'
require 'faker'

FactoryGirl.define do
  sequence :random_code do |n|
    ((('A'..'Z').to_a + ('1'..'9').to_a) * 6).sample(6).join
  end

  factory :code, :class => PpwmMatcher::Code do
    value { generate(:random_code) }

    factory :code_with_users do
      ignore do
        users_count 2
      end

      after(:create) do |code, evaluator|
        FactoryGirl.create_list(:user, evaluator.users_count, code: code)
      end
    end
  end

  factory :user, :class => PpwmMatcher::User do
    email { Faker::Internet.email }
  end
end
