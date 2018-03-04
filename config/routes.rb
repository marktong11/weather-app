Rails.application.routes.draw do
  devise_for :users
	root 'users#my_locations'
	get 'my_locations', to: 'users#my_locations'
	get 'search_locations', to: 'locations#search'
	get 'search_weather', to: 'locations#weather'
	resources :user_locations, only: [:create, :destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
