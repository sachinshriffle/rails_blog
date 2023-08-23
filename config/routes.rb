Rails.application.routes.draw do
	# root "articles#index"
	# resources :articles do
	# 	resources :comments
	# end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get "/users", to: "users#index"
  # post "/users", to: "users#create"
  # patch "/users/:id", to: "users#update"
  # get "/users/:id", to: "users#show"
  # delete "/users/:id", to: "users#delete"
  # put "/users/:id", to: "users#update"
  # get "users/download_pdf/:id", to: "users#download_pdf"
  # get "/users/stream", to: "users#stream"
  resources :users 
end
