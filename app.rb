require 'logger'
require 'sinatra'
require 'sinatra_auth_github'
require 'sinatra/activerecord'
require './models/code'
require './models/user'

module PpwmMatcher
  class App < Sinatra::Base
    enable :sessions

    set :github_options, {
      :scopes    => "user",
      :secret    => ENV['GITHUB_CLIENT_SECRET'],
      :client_id => ENV['GITHUB_CLIENT_ID'],
    }
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
<p>Enter your code:</p>
<form action='/code' method='POST'>
  <input type='text' name='code' value=''>
  <input type='submit'>
</form>
PAIR
    end

    get '/code/create' do
      codes = Code.create_pair
      codes.map { |c| [c.id, c.value] }.inspect
    end

    post '/code' do
      authenticate!

      # Store the user, check code
      user = User.find_or_create_by_email(github_user.email)
      code = Code.find_by_value(params['code'])

      # Unknown code? Try again
      redirect '/?error=1' unless code

      LOGGER.info "Matched #{user.email} to #{code.value}"

      user.update_with_code(code)

      if code.pair_claimed?
        message = "Your pair is #{code.paired_user.email}! Click here to send an email and set up a pairing session! Don't be shy!"
      else
        message = "Your pair hasn't signed in yet, keep your fingers crossed!"
      end

      <<-PAIR
You submitted code #{code.value}<br>
#{message}
PAIR
    end

    get '/orgs/:id' do
      github_organization_authenticate!(params['id'])
      "Hello There, #{github_user.name}! You have access to the #{params['id']} organization."
    end

    get '/publicized_orgs/:id' do
      github_publicized_organization_authenticate!(params['id'])
      "Hello There, #{github_user.name}! You are publicly a member of the #{params['id']} organization."
    end

    get '/teams/:id' do
      github_team_authenticate!(params['id'])
      "Hello There, #{github_user.name}! You have access to the #{params['id']} team."
    end

    get '/logout' do
      logout!
      redirect 'https://github.com'
    end
  end
end
