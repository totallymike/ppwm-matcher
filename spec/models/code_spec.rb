require 'spec_helper'

describe PpwmMatcher::Code do
  it "should have a valid factory" do
    FactoryGirl.build_stubbed(:code)
  end

  subject(:code) { FactoryGirl.create(:code) }

  describe "should be able to have multiple users" do
    subject(:code) { FactoryGirl.create(:code_with_users) }

    it "has a users method" do
      expect { code.users }.not_to raise_error
    end

    it "has more than one user associated" do
      expect(code.users.length).to have_at_least(1).items
    end
    it "returns a iterable list of users" do
      code.users.each do |user|
        expect(user).to be_instance_of(PpwmMatcher::User)
      end
    end
  end
end
