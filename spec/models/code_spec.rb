require 'spec_helper'

describe PpwmMatcher::Code do
  subject(:code) { FactoryGirl.create(:code) }

  describe "can have multiple users" do
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

  describe "generates random code automatically" do
    subject(:code) { FactoryGirl.build(:code, :value => nil) }

    it "should generate code on save" do
      expect(code.value).to be_nil

      code.save

      expect(code.value).not_to be_nil
    end

    it "should not generate the same value repeatedly" do
      codes = (1..10).map{ code.generate_string }

      expect(codes.uniq).to have_exactly(10).items
    end
  end
end
