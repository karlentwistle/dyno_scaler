# frozen_string_literal: true

require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  constraints Clearance::Constraints::SignedIn.new(&:admin?) do
    mount Sidekiq::Web => '/sidekiq'
  end
end
