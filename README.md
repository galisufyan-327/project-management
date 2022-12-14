# README

* Ruby version
  - 3.0.3

* System dependencies
  - rails 7.0.4
  - postgresql


* Project Setup
  - Create 'master.key' file in '/config' directory
  - Add following key in 'master.key' file
  - d0711cac1e2167ba06a609ecaa44c848

* Run these commands in app directory
```
gem install bundler
bundle install
```
* Database Setup
  - Create '.env' file at project root
  - Add your postgresql username and password in .env
```
  Example:
    DB_USER_NAME = user
    DB_PASSWORD = password
```
* Database Creation
```
rails db:create
rails db:migrate
```


* How to run the test suite
```
  rails test
```

* ...
