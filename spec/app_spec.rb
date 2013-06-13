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
      authorize 'admin', 'ZOMGSECRET'

      expect {
        post '/code/import', :codes => codes
      }.to change{ PpwmMatcher::Code.count }.by codes.length

      expect(PpwmMatcher::Code.where(:value => codes).length).to eql(codes.length)
    end

    it "requires basic auth" do
      post '/code/import', :codes => codes

      expect(last_response).not_to be_ok
    end

    it "can accept codes as raw input" do
      authorize 'admin', 'ZOMGSECRET'

      expect {
        post '/code/import', codes.join("\n"), "CONTENT_TYPE" => "text/plain"
      }.to change{ PpwmMatcher::Code.count }.by codes.length

      expect(PpwmMatcher::Code.where(:value => codes).length).to eql(codes.length)
    end
  end

  describe "POST /code" do
    let(:user) { make_user(:login => 'test_user') }

    it "asks the user to reenter the code" do
      post '/code', :code => 'FOOBAR'

      expect(last_response.headers['Location']).to include('github.com')
    end

    it "redirects when an invalid code is provided" do
      login_as user

      post '/code', :code => 'FOOBAR'

      expect(last_response.body).to include("Unknown code, try again")
      expect(last_response.body).to include("Enter your code")
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
