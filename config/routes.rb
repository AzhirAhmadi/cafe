# == Route Map
#
#                            Prefix Verb   URI Pattern                                                                              Controller#Action
#                             login POST   /api/login(.:format)                                                                     devise_api/sessions#create {:format=>"json"}
#                            logout DELETE /api/logout(.:format)                                                                    devise_api/sessions#destroy {:format=>"json"}

#           coffee_shop_board_games POST   /api/coffee_shops/:coffee_shop_id/board_games(.:format)                                  board_games#create {:format=>"json"}
#            coffee_shop_board_game PATCH  /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                              board_games#update {:format=>"json"}
#                                   PUT    /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                              board_games#update {:format=>"json"}
# coffee_shop_board_game_deactivate DELETE /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                              board_games#deactivate {:format=>"json"}

#                coffee_shop_events POST   /api/coffee_shops/:coffee_shop_id/events(.:format)                                       events#create {:format=>"json"}
#                 coffee_shop_event PATCH  /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                   events#update {:format=>"json"}
#                                   PUT    /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                   events#update {:format=>"json"}
#      coffee_shop_event_deactivate DELETE /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                   events#deactivate {:format=>"json"}

#                      coffee_shops POST   /api/coffee_shops(.:format)                                                              coffee_shops#create {:format=>"json"}
#                       coffee_shop PATCH  /api/coffee_shops/:id(.:format)                                                          coffee_shops#update {:format=>"json"}
#                                   PUT    /api/coffee_shops/:id(.:format)                                                          coffee_shops#update {:format=>"json"}
#            coffee_shop_deactivate DELETE /api/coffee_shops/:id(.:format)                                                          coffee_shops#deactivate {:format=>"json"}

#                             users POST   /api/users(.:format)                                                                     users#create {:format=>"json"}
#                              user PATCH  /api/users/:id(.:format)                                                                 users#update {:format=>"json"}
#                                   PUT    /api/users/:id(.:format)                                                                 users#update {:format=>"json"}
#                   user_deactivate DELETE /api/users/:id(.:format)                                                                 users#deactivate {:format=>"json"}
#                           profile GET    /api/profile(.:format)                                                                   users#profile {:format=>"json"}

#                rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                               active_storage/blobs#show
#         rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format) active_storage/representations#show
#                rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                              active_storage/disk#show
#         update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                      active_storage/disk#update
#              rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                           active_storage/direct_uploads#create
#

Rails.application.routes.draw do
  devise_for :users, class_name: 'ApiUser', skip: :all
  scope path: 'api', defaults: { format: 'json' } do
    
    devise_scope :user do
      post    'login',        to: 'devise_api/sessions#create'
      delete  'logout',       to: 'devise_api/sessions#destroy'
    end

    resources :coffee_shops, only: [:create, :update, :show, :index] do
      resources :board_games, only: [:create, :update, :show, :index]
      delete 'board_games/:id', to: 'board_games#deactivate', as: "board_game_deactivate"
      resources :events, only: [:create, :update, :show, :index] do
        resources :tables, only: [:create, :update, :show, :index]
        delete 'tables/:id', to: 'tables#deactivate', as: "table_deactivate"  
      end
      delete 'events/:id', to: 'events#deactivate', as: "event_deactivate"
    end 
    delete 'coffee_shops/:id', to: 'coffee_shops#deactivate', as: "coffee_shop_deactivate"
    
    resources :users, only:[:create, :update, :show, :index]
    delete 'users/:id', to: 'users#deactivate', as: "user_deactivate"
    get '/profile', to: 'users#profile'
  end
end
