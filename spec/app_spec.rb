require 'spec_helper'

describe PpwmMatcher::App do
  include Rack::Test::Methods

  def app
    described_class.new
  end

  describe "/codes/import" do
    let(:codes) { (1..10).map{ FactoryGirl.generate(:random_code) } }

    it "accepts a list of codes and creates them" do
      expect {
        post '/code/import', :codes => codes
      }.to change{ PpwmMatcher::Code.count }.by codes.length
    end
  end
end
