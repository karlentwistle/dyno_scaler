# frozen_string_literal: true

Rails.application.routes.draw do
  resources :logs, only: %i[create]
  resources :pipelines, only: %i[new create index show destroy]

  draw(:admin)

  root 'pipelines#index'
end
