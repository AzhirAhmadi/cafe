Rails.application.routes.draw do
  scope path: 'api' do
    devise_for :users, class_name: 'ApiUser', skip: :all
    devise_scope :user do
      post    'login',        to: 'devise_api/sessions#create'
      delete  'logout',       to: 'devise_api/sessions#destroy'
    end
  
    resources :user, only:[:show] do
      
    end
  
    get '/profile', to: 'users#profile'
  end
end
