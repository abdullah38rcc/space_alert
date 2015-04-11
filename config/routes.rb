Rails.application.routes.draw do
  resources :bexrbs

  resources :news do
  	collection do
  		get 'mobile/feeds', action: :mobile_feeds
  	end
  end

  resources :feeds do
  	member do
	   get 'read'
	end
  end

  root to: 'visitors#index'
  devise_for :users
  resources :users
end
