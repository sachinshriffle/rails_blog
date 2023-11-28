Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end
	root "articles#index"
  # resources :users, only: [:create]
	resources :articles , only: [:index , :create]
  get '/users', to: "users#create"
	# 	resources :comments
	# end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # get "/users", to: "users#index"
  # post "/users", to: "users#create"
  # patch "/users/:id", to: "users#update"
  # get "/users/:id", to: "users#show"
  # delete "/users/:id", to: "users#delete"
  # put "/users/:id", to: "users#update"
  # get "users/download_pdf/:id", to: "users#download_pdf"
  # get "/users/stream", to: "users#stream"
  # resources :users do
  # 	resources :articles ,shallow: true
  # end
end
