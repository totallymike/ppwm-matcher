require 'logger'
require 'sinatra'
require 'sinatra_auth_github'
require 'ppwm_matcher/models/code'
require 'ppwm_matcher/models/user'
require 'ppwm_matcher/models/code_matcher'
require 'ppwm_matcher/models/github_auth'

module PpwmMatcher
  class App < Sinatra::Base
    enable :sessions
    enable :prefixed_redirects
    enable :logging

    set :github_options, PpwmMatcher::GithubAuth.options

    configure do
      set :admin_username, ENV.fetch('ADMIN_USERNAME') { 'admin' }
      set :admin_password, ENV.fetch('ADMIN_PASSWORD') { 'ZOMGSECRET' }
    end

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

      def protected!
        return if authorized?

        headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
        halt 401, "Not authorized\n"
      end

      def authorized?
        auth =  Rack::Auth::Basic::Request.new(request.env)

        auth.credentials == [settings.admin_username, settings.admin_password]
      rescue
        false
      end
    end

    get '/' do
      authenticate!
      setup_for_root_path
      erb :index, layout: :layout
    end

    get '/unauthenticated' do
      erb :unauthenticated, layout: :layout
    end

    get '/code/create' do
      code = Code.create
    end

    post '/code/import' do
      protected!

      codes = params['codes'] || request.body.read.split("\n")

      codes.each do |code|
        Code.create!(:value => code)
      end
    end

    get '/code' do
      authenticate!

      user = User.current(github_user) # TODO: refactor to helper method ?
      @pair = user.pair
      @code_value = user.code.value
      erb :code, layout: :layout
    end

    post '/code' do
      authenticate!

      matcher = CodeMatcher.new({
        github_user: github_user,
        email: params['email'],
        code: params['code']
      })

      if matcher.valid?
        code, user = matcher.assign_code_to_user
        @pair = user.pair
        @code_value = code.value
        erb :code, layout: :layout
      else
        setup_for_root_path(matcher.error_messages)
        erb :index, layout: :layout
      end
    end

    def setup_for_root_path(messages = nil)
      @code = params['code']
      @messages = messages
      @email = params['email'] || github_user.email
      @login = github_user.login
    end

  end
end
