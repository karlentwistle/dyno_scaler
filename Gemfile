# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby file: '.ruby-version'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.0.0'

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use postgresql as the database for Active Record
gem 'pg', '~> 1.5'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '~> 7.0'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 5.2'

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
gem 'bcrypt', '~> 3.1.20'

# Rails authentication with email & password.
gem 'clearance'

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Simple, efficient background processing for Ruby.
gem 'sidekiq'

# A scheduling add-on for Sidekiq
gem 'sidekiq-cron'

# Ruby HTTP client for the Heroku API.
gem 'platform-api'

# Tailwind CSS for Rails
gem 'tailwindcss-rails', '~> 3.0'

# ActiveHash is a simple base class that allows you to use a ruby hash as a readonly datasource
gem 'active_hash'

# A syslog (rfc5424) parser written in Ruby and specifically targeting Heroku's http log drain.
gem 'heroku-log-parser'

# Sentry's Ruby SDK allows users to report messages, exceptions, and tracing events.
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'sentry-sidekiq'

# OmniAuth: Standardized Multi-Provider Authentication
gem 'omniauth'
gem 'omniauth-google-oauth2'
gem 'omniauth-rails_csrf_protection'

# Use Sass to process CSS
# gem "sassc-rails"

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# Very simple Roles library
gem 'rolify'

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri mingw x64_mingw]

  gem 'byebug'

  # Shim to load environment variables from .env into ENV in development.
  gem 'dotenv-rails', groups: %i[development test]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem 'web-console'

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
  gem 'rubocop', require: false
  gem 'rubocop-capybara', require: false
  gem 'rubocop-factory_bot', require: false
  gem 'rubocop-performance', require: false
  gem 'rubocop-rails', require: false
  gem 'rubocop-rspec', require: false

  # Patch-level verification for bundler.
  gem 'bundler-audit'

  # A static analysis security vulnerability scanner for Ruby on Rails applications.
  gem 'brakeman'
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem 'capybara'
  gem 'cuprite'
  gem 'faker'
  gem 'webmock'
end

gem 'factory_bot_rails', groups: %i[development test]
gem 'rspec-rails', groups: %i[development test]
