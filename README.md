## Pair Program With Me - Matcher

A sinatra app with github auth for Avdi

* see [ppwm](https://github.com/avdi/ppwm), [a ppwm scraper](https://github.com/martyhines/pair_with_me), and [rubypair](https://github.com/rubypair/rubypair)

## TODO

* a way to add codes
* persist codes, persist matched users
* link to user emails
* store data in the session
* fix deprecation warnings from github auth
* don't let codes be re-used by other users
* analytics?

## Setup

  ```bash
  bundle
  heroku addons:add heroku-postgresql:dev
  # create a new github application https://github.com/account/applications
  # your callback url should be hostname + /auth/github/callback
  heroku config:set GITHUB_CLIENT_ID="<from GH>" GITHUB_CLIENT_SECRET="<from GH>"
  ```

## License

Ask Avdi
