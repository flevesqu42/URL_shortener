Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'urls#new'

  # Resources endpoint for shortened URLs
  resources :urls, only: [:show, :new, :create]

  # Administration endpoints
  namespace :admin do
    root 'urls#index'

    resources :urls, only: [:index, :destroy]
  end

  # Default path will be redirection with ID
  get '/:id', to: 'urls#redirect', as: 'redirect'
end
