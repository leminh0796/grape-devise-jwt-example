# README

devise-jwt and grape example

* Ruby version
  * 3.1.2
* Rails version
  * 7.0.3.1
* How to run (without Docker)
  * Install ruby (macos)
  ```
    brew install rbenv
    rbenv install 3.1.2
    rbenv global 3.1.2
    rbenv rehash
    ruby -v
  ```
  * Preparation
  ```
    gem install bundler
    bundler install
  ```
  * Install PostgreSQL manually
  * Use/Change db connection credentials in config/database.yml
  ```
  # first time run
  rails db:create
  # if have new migrations
  rails db:migrate
  # drop db
  rails db:drop
  ```
  * Start server
  ```
  rails server
  ```
  * Interactive shell
  ```
  rails console
  ```
  * Looking for api docs? Go to /api-docs
