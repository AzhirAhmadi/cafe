# == Route Map
#
#                    Prefix Verb   URI Pattern                                                                              Controller#Action
#                     login POST   /api/login(.:format)                                                                     devise_api/sessions#create
#                    logout DELETE /api/logout(.:format)                                                                    devise_api/sessions#destroy
#                      user GET    /api/user/:id(.:format)                                                                  user#show
#                   profile GET    /api/profile(.:format)                                                                   users#profile
#        rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
# rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#        rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
# update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#      rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
#

Rails.application.routes.draw do
  devise_for :users, class_name: 'ApiUser', skip: :all
  scope path: 'api' do
    
    devise_scope :user do
      post    'login',        to: 'devise_api/sessions#create'
      delete  'logout',       to: 'devise_api/sessions#destroy'
    end
  
    resources :users, only:[:create, :update] do
      delete '', to: 'users#deactivate', as: "deactivate"
    end
  
    get '/profile', to: 'users#profile'
  end
end
