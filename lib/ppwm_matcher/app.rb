require 'logger'
require 'sinatra'
require 'sinatra_auth_github'
require 'ppwm_matcher/models/code'
require 'ppwm_matcher/models/user'
require 'ppwm_matcher/models/github_auth'

module PpwmMatcher
  class App < Sinatra::Base
    enable :sessions
    enable :prefixed_redirects
    enable :logging

    set :github_options, PpwmMatcher::GithubAuth.options

    register Sinatra::Auth::Github

    # actions that don't require GH auth
    open_actions = %w(unauthenticated code/import)

    before '/*' do
      return if open_actions.include? params[:splat].first
      authenticate!
    end

    helpers do
      def repos
        github_request("user/repos")
      end
    end

    get '/' do
      @message = ''
      @email = github_user.email
      @login = github_user.login

      if params['error']
        @message = "Unknown code, try again"
      end

      erb :index, layout: :layout
    end

    get '/unauthenticated' do
      erb :unauthenticated, layout: :layout
    end

    get '/code/create' do
      code = Code.create
    end

    post '/code/import' do
      params['codes'].each do |code|
        Code.create!(:value => code)
      end
    end

    post '/code' do
      # Store the user, check code
      user = User.where(:email => params['email']).first_or_create
      code = Code.where(:value => params['code']).first


      if code
        code.assign_user user
        logger.info "Matched #{user.email} to #{code.value}"

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
