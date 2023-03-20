# frozen_string_literal: true

Rails.application.routes.draw do
  resources :logs, only: %i[create]
  resources :pipelines, only: %i[new create index show destroy]

  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => 'sidekiq'
end
