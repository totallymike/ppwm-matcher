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

      @message = ''
      @email = github_user.email
      @login = github_user.login

      if params['error']
        @message = "Unknown code, try again"
      end

      erb :index, layout: :layout
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

      if code
        LOGGER.info "Matched #{user.email} to #{code.value}"

        if user.has_pair?
          @message = "Your pair is #{user.pair.email}! Click here to send an email and set up a pairing session! Don't be shy!"
        else
          @message = "Your pair hasn't signed in yet, keep your fingers crossed!"
        end

        @code_value = code.value
        erb :code, layout: :layout
      else
        redirect '/?error=1'
      end
    end

  end
end
