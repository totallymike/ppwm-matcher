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

  describe ".update_or_create" do
    let(:github_user) do
      double("github_user", :gravatar_id => rand(1..5000),
                            :login       => Faker::Internet.user_name,
                            :name        => Faker::Name.name,
                            :email       => Faker::Internet.email
            )
    end

    describe "when a user already exists" do
      let!(:user) { FactoryGirl.create(:user, :github_login => github_user.login) }

      it "finds and returns an existing user" do
        expect(
          described_class.update_or_create(user.email, github_user)
        ).to eql(user)
      end

      it "sets the users email to the provided value" do
        new_email = Faker::Internet.email

        user = described_class.update_or_create(new_email, github_user)

        expect(user.email).to eql(new_email)
      end
    end

    describe "when no user exists" do
      it "creates the user with the provided information" do
        user = described_class.update_or_create(github_user.email, github_user)

        expect(user.email).to         eql(github_user.email)
        expect(user.gravatar_id).to   eql(github_user.gravatar_id)
        expect(user.name).to          eql(github_user.name)
        expect(user.github_login).to  eql(github_user.login)
      end

      it "should returned a saved user" do
        user = described_class.update_or_create(github_user.email, github_user)

        expect(user).not_to be_changed
      end
    end
  end
end
