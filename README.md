## Pair Program With Me - Matcher

A sinatra app with github auth for Avdi

## TODO

* add codes
* persist code
* surface user emails
* use session data
* fix deprecation warnings

## Setup

  ```bash
  bundle
  heroku addons:add heroku-postgresql:dev
  # create a new github application https://github.com/account/applications
  heroku config:set GITHUB_CLIENT_ID="<from GH>" GITHUB_CLIENT_SECRET="<from GH>"
  ```

