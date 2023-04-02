# frozen_string_literal: true

Rails.application.routes.draw do
  resources :passwords, controller: 'clearance/passwords', only: %i[create new]
  resource :session, controller: 'clearance/sessions', only: [:create]

  resources :users, controller: 'users', only: [:create] do
    resource :password,
             controller: 'clearance/passwords',
             only: %i[edit update]
  end

  get '/sign_in' => 'clearance/sessions#new', as: 'sign_in'
  delete '/sign_out' => 'clearance/sessions#destroy', as: 'sign_out'
  get '/sign_up' => 'users#new', as: 'sign_up'
  resources :logs, only: %i[create]
  resources :pipelines, only: %i[index show new edit create update destroy]

  post '/auth/:provider/callback', to: 'omniauth_callbacks#developer'

  draw(:admin)

  root 'pipelines#index'
end
