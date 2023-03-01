Rails.application.routes.draw do
  resources :pipelines, only: [:new, :create, :index, :show, :destroy]
end
