Rails.application.routes.draw do
  get "game/index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  root "game#new"

  get    '/game/new', to: 'game#new', as: :new_game
  post   '/game/create', to: 'game#create'
  get    '/game', to: 'game#show', as: :game
  post   '/game/bet', to: 'game#bet', as: :game_bet
  post   '/game/hit', to: 'game#hit', as: :game_hit
  post   '/game/stand', to: 'game#stand', as: :game_stand
  post   '/game/new_round', to: 'game#new_round', as: :game_new_round

end
