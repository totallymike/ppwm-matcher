require 'logger'
require 'active_record'
require 'sinatra/activerecord'

case ENV['RACK_ENV']
when 'test', 'development'
  LOGGER = Logger.new(
    File.expand_path(
      "../log/#{ENV['RACK_ENV']}.log",
      __FILE__))
else
  LOGGER = Logger.new($stdout)
end

ActiveRecord::Base.logger = LOGGER

$:.unshift(File.expand_path('../lib', __FILE__))

require_relative 'lib/ppwm_matcher/app.rb'

module PpwmMatcher
  class App < Sinatra::Base
    PpwmMatcher::App.register Sinatra::ActiveRecordExtension

    set :database_file,
        File.expand_path('../config/database.yml', __FILE__)
  end
end
