require 'spec_helper'

describe PpwmMatcher::CodeMatcher do
  let(:github_user) { OpenStruct.new({ login: 'x', gravatar_id: 'x' }) }

  describe "user creation" do
    before(:each) { PpwmMatcher::User.delete_all }
    let(:existing_user) { FactoryGirl.create(:user, email: 'test2@example.com', github_login: github_user.login) }
    let(:code_klass) { mock(PpwmMatcher::Code).as_null_object }
    let(:default_args) do
      {
        github_user: github_user,
        email: 'ppwm1@example.com',
        code: 'xxxx',
        code_klass: code_klass
      }
    end

    it "creates a new user" do
      args = default_args
      expect { PpwmMatcher::CodeMatcher.new(args) }.to change { PpwmMatcher::User.count }
    end

    it "does not need to create a new user" do
      args = default_args.merge!({ email: existing_user.email })
      expect { PpwmMatcher::CodeMatcher.new(args) }.not_to change { PpwmMatcher::User.count }
    end

    it "cannot create the same github user twice" do
      args = default_args.merge!({ email: "x-#{existing_user.email}" })
      expect { PpwmMatcher::CodeMatcher.new(args) }.not_to change { PpwmMatcher::User.count }
    end
  end

  describe "valid?" do
    let(:existing_code) { FactoryGirl.create(:code, value: 'XXXX') }
    let(:default_args) do
      {
        github_user: github_user,
        email: 'ppwm1@example.com',
        code: existing_code.value
      }
    end

    it "yes" do
      args = default_args
      expect(PpwmMatcher::CodeMatcher.new(args).valid?).to be_true
    end

    it "not when code is missing" do
      args = default_args.merge!({ code: 'xxxx' })
      expect(PpwmMatcher::CodeMatcher.new(args).valid?).to be_false
    end

    it "not when user email is blank" do
      args = default_args.merge!({ email: nil })
      expect(PpwmMatcher::CodeMatcher.new(args).valid?).to be_false
    end

    it "not when both pairs have been assigned to the code" do
      pair1 = FactoryGirl.create(:user, code: existing_code, email: "pair1@example.com")
      pair2 = FactoryGirl.create(:user, code: existing_code, email: "pair2@example.com")

      args = default_args.merge!({ email: "nopair@example.com" })
      matcher = PpwmMatcher::CodeMatcher.new(args)
      expect(matcher.assign_code_to_user).to be_false
      expect(matcher.valid?).to be_false
    end
  end

  describe "assign_code_to_user" do
    it "does the assignment" do
      existing_code = FactoryGirl.create(:code, value: 'XXXX')
      args = {
        github_user: github_user,
        email: 'ppwm1@example.com',
        code: existing_code.value
      }

      PpwmMatcher::Code.any_instance.should_receive(:assign_user)
      matcher = PpwmMatcher::CodeMatcher.new(args)
      matcher.assign_code_to_user
    end
  end
end
