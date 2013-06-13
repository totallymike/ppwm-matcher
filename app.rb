require 'logger'
require 'sinatra'
require 'sinatra_auth_github'
require 'sinatra/activerecord'
require './models/code'
require './models/user'
require './models/github_auth'

module PpwmMatcher
  class App < Sinatra::Base
    enable :sessions

    set :github_options, PpwmMatcher::GithubAuth.options
    LOGGER = Logger.new(STDOUT)

    register Sinatra::Auth::Github

    helpers do
      def repos
        github_request("user/repos")
      end
    end

    get '/' do
      authenticate!
      message = params['error'] ? "<strong>Unknown code, try again</strong>" : ""
      <<-PAIR
<h1>Hello there, #{github_user.login}!</h1>
#{message}
<form action='/code' method='POST'>
  <p>
    Enter your code:
    <input type='text' name='code' value=''>
  </p>
  <p>
    Email:
    <input type='text' name='email' value='#{github_user.email}'>
  </p>
  <input type='submit'>
</form>
PAIR
    end

    get '/code/create' do
      code = Code.create
    end

    post '/code' do
      authenticate!

      # Store the user, check code
      user = User.where(:email => params['email']).first_or_create
      code = Code.where(:code  => params['code']).first

      code.assign_user user

      # Unknown code? Try again
      redirect '/?error=1' unless code

      LOGGER.info "Matched #{user.email} to #{code.value}"

      if user.has_pair?
        message = "Your pair is #{user.pair.email}! Click here to send an email and set up a pairing session! Don't be shy!"
      else
        message = "Your pair hasn't signed in yet, keep your fingers crossed!"
      end

      <<-PAIR
You submitted code #{code.value}<br>
#{message}
PAIR
    end

  end
end
