Rails.application.routes.draw do
  resources :games, only: %i[create show] do
    resources :pitches, only: [:create]
  end
end
