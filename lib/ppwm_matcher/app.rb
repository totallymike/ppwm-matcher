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

    register Sinatra::Auth::Github

    helpers do
      def repos
        github_request("user/repos")
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
      params['codes'].each do |code|
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
