require 'spec_helper'

describe PpwmMatcher::Code do
  it "should have a valid factory" do
    FactoryGirl.build_stubbed(:code)
  end
end
