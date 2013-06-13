require 'spec_helper'

describe PpwmMatcher::App do
  include Rack::Test::Methods
  include Sinatra::Auth::Github::Test::Helper

  def app
    described_class.new
  end

  describe "/codes/import" do
    before do
      raise "I just saved your butt" if ENV['RACK_ENV'] != 'test'
      PpwmMatcher::Code.delete_all
    end

    let(:codes) { (1..10).map{ FactoryGirl.generate(:random_code) } }

    it "accepts a list of codes and creates them" do
      expect {
        post '/code/import', :codes => codes
      }.to change{ PpwmMatcher::Code.count }.by codes.length

      expect(PpwmMatcher::Code.where(:value => codes).length).to eql(codes.length)
    end
  end

  describe "POST /code" do
    let(:user) { make_user(:login => 'test_user') }

    it "redirects to github for authentication when not logged in" do
      post '/code', :code => 'FOOBAR'

      expect(last_response.redirect?).to be_true
      expect(last_response.headers['Location']).to include('github.com')
    end

    it "redirects when an invalid code is provided" do
      login_as user

      post '/code', :code => 'FOOBAR'

      expect(last_response.redirect?).to be_true
      expect(last_response.headers['Location']).to include('/?error=1')
    end

    it "when a valid code is provided it shows the code" do
      login_as user
      code = FactoryGirl.create(:code)

      post '/code', :code => code.value, :email => user.email

      expect(last_response.body).to include(code.value)
    end

    it "associates the current user to the code provided"  do
      login_as user
      code = FactoryGirl.create(:code)

      post '/code', :code => code.value, :email => user.email

      expect(code.users(true).where(:email => user.email).size).to eql(1)
    end
  end
end
