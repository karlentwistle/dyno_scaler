web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 2 -q within_one_minute
release: rails db:migrate
