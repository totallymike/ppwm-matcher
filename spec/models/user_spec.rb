require 'spec_helper'

describe PpwmMatcher::User do
  let(:pair_user) { FactoryGirl.create(:user) }
  let(:code)      { FactoryGirl.create(:code) }

  subject(:user)  { FactoryGirl.create(:user) }

  describe "#has_pair?" do
    it "returns false when no code has been associated" do
      expect(user.has_pair?).to be_false
    end

    it "returns false when no other user has our code" do
      code.users << user

      expect(user.has_pair?).to be_false
    end

    it "is true when one other user has our code" do
      code.assign_user(user)
      code.assign_user(pair_user)

      expect(user.has_pair?).to be_true
    end
  end

  describe "#pair" do
    it "returns nil when no users share our code" do
      code.assign_user  user

      expect(user.pair).to be_nil
    end

    it "returns another user that shares our code" do
      code.assign_user user
      code.assign_user pair_user

      expect(pair_user.pair).to eql(user)
      expect(user.pair).to      eql(pair_user)
    end
  end
end
