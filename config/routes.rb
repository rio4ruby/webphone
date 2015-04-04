Rails.application.routes.draw do


  resources :rtc_sessions
  resources :authorizations_e911_contexts
  resources :e911_contexts
  resources :authorizations
  mount Upmin::Engine => '/admin'
  root to: 'visitors#index'
  devise_for :users
  resources :users

  get    '/pages/main'                 => 'pages#main'
  get    '/pages/authorize'            => 'pages#authorize'
  get    '/oauth/callback'             => 'authorizations#callback'


end
