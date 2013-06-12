Gem::Specification.new do |s|
  s.name        = "ppwm-matcher"
  s.version     = "0.0.1"
  s.authors     = ['Avdi Grimm']
  s.email       = [""]
  s.homepage    = "https://github.com/rubyrogues/ppwm-matcher"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{config,db,lib,models,public}/**/*"]

  s.add_dependency 'sinatra_auth_github'
  s.add_dependency 'thin'
  s.add_dependency "activerecord"
  s.add_dependency "sinatra-activerecord"
  s.add_dependency "pg"
  s.add_dependency "rake"
end
