require 'factory_girl'

FactoryGirl.define do
  sequence :random_code do |n|
    ((('A'..'Z').to_a + ('1'..'9').to_a) * 6).sample(6).join
  end

  factory :code, :class => PpwmMatcher::Code do
    value { generate(:random_code) }
  end
end
