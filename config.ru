ENV['RACK_ENV'] ||= 'development'
require "rubygems"
require "bundler/setup"
require './app'
use Rack::Static,
  :urls => [],
  :root => "public"

run lambda { |env|
  [
    200,
    {
      'Content-Type'  => 'image/x-icon',
      'Cache-Control' => 'public, max-age=86400'
    },
    File.open('public/favicon.ico', File::RDONLY)
  ]
}

run PpwmMatcher::App
