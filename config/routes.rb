# frozen_string_literal: true

Rails.application.routes.draw do
  resources :pipelines, only: %i[new create index show destroy]
end
