# frozen_string_literal: true

Rails.application.routes.draw do
  resources :logs, only: %i[create]
  resources :pipelines, only: %i[index show new edit create update destroy]

  draw(:admin)

  root 'pipelines#index'
end
