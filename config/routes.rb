
BeOneAdmin::Engine.routes.draw do
  root to: "main#index" ,as: :admin_root
  extend BeOneAdmin::RoutableConcern

  %w{sign_in remind}.each do |method|
    post method , to: "sessions##{method}", as: :"admin_#{method}"
  end
  %w{forgot login sign_out }.each do |method|
    get method , to: "sessions##{method}", as: :"admin_#{method}"
  end

  get 'restore/:token' => 'sessions#remind', as: 'remind'

  namespace :uploads do
  end
  namespace :journals do
    resources :logs, only: [:index,:show,:new]
    resources :versions, only: [:index,:show,:new]
  end

  namespace :settings do
    resources :menus do
      patch :move, on: :member
    end
    resources :users, concerns: :habtm_concern
    resources :permissions , concerns: :habtm_concern
    resources :admin_user_groups , concerns: :habtm_concern
    resources :roles , concerns: :habtm_concern
    resources :emails 
    resources :settings 
    resources :notifications , concerns: :has_many_concern
    resources :confirmations , only: [:index]
  end
end
