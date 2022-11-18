Rails.application.routes.draw do
  # Defines the root path route ("/")
  root 'urls#new'

  # Resources endpoint for shortened URLs
  resources 'urls', only: [:index, :show, :new, :create, :update]

  # default behaviour with ID
  get '/:id', to: 'urls#show'
end
