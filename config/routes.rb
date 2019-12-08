# == Route Map
#
#                                       Prefix Verb   URI Pattern                                                                                  Controller#Action
#                                        login POST   /api/login(.:format)                                                                         devise_api/sessions#create {:format=>"json"}
#                                       logout DELETE /api/logout(.:format)                                                                        devise_api/sessions#destroy {:format=>"json"}
#                      coffee_shop_board_games GET    /api/coffee_shops/:coffee_shop_id/board_games(.:format)                                      board_games#index {:format=>"json"}
#                                              POST   /api/coffee_shops/:coffee_shop_id/board_games(.:format)                                      board_games#create {:format=>"json"}
#                       coffee_shop_board_game GET    /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                                  board_games#show {:format=>"json"}
#                                              PATCH  /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                                  board_games#update {:format=>"json"}
#                                              PUT    /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                                  board_games#update {:format=>"json"}
#            coffee_shop_board_game_deactivate DELETE /api/coffee_shops/:coffee_shop_id/board_games/:id(.:format)                                  board_games#deactivate {:format=>"json"}
#           coffee_shop_event_table_enrolments GET    /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:table_id/enrolments(.:format)     enrolments#index {:format=>"json"}
#                                              POST   /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:table_id/enrolments(.:format)     enrolments#create {:format=>"json"}
# coffee_shop_event_table_enrolment_deactivate DELETE /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:table_id/enrolments/:id(.:format) enrolments#deactivate {:format=>"json"}
#                     coffee_shop_event_tables GET    /api/coffee_shops/:coffee_shop_id/events/:event_id/tables(.:format)                          tables#index {:format=>"json"}
#                                              POST   /api/coffee_shops/:coffee_shop_id/events/:event_id/tables(.:format)                          tables#create {:format=>"json"}
#                      coffee_shop_event_table GET    /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:id(.:format)                      tables#show {:format=>"json"}
#                                              PATCH  /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:id(.:format)                      tables#update {:format=>"json"}
#                                              PUT    /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:id(.:format)                      tables#update {:format=>"json"}
#           coffee_shop_event_table_deactivate DELETE /api/coffee_shops/:coffee_shop_id/events/:event_id/tables/:id(.:format)                      tables#deactivate {:format=>"json"}
#                           coffee_shop_events GET    /api/coffee_shops/:coffee_shop_id/events(.:format)                                           events#index {:format=>"json"}
#                                              POST   /api/coffee_shops/:coffee_shop_id/events(.:format)                                           events#create {:format=>"json"}
#                            coffee_shop_event GET    /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                       events#show {:format=>"json"}
#                                              PATCH  /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                       events#update {:format=>"json"}
#                                              PUT    /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                       events#update {:format=>"json"}
#                 coffee_shop_event_deactivate DELETE /api/coffee_shops/:coffee_shop_id/events/:id(.:format)                                       events#deactivate {:format=>"json"}
#                                 coffee_shops GET    /api/coffee_shops(.:format)                                                                  coffee_shops#index {:format=>"json"}
#                                              POST   /api/coffee_shops(.:format)                                                                  coffee_shops#create {:format=>"json"}
#                                  coffee_shop GET    /api/coffee_shops/:id(.:format)                                                              coffee_shops#show {:format=>"json"}
#                                              PATCH  /api/coffee_shops/:id(.:format)                                                              coffee_shops#update {:format=>"json"}
#                                              PUT    /api/coffee_shops/:id(.:format)                                                              coffee_shops#update {:format=>"json"}
#                       coffee_shop_deactivate DELETE /api/coffee_shops/:id(.:format)                                                              coffee_shops#deactivate {:format=>"json"}
#                                        users GET    /api/users(.:format)                                                                         users#index {:format=>"json"}
#                                              POST   /api/users(.:format)                                                                         users#create {:format=>"json"}
#                                         user GET    /api/users/:id(.:format)                                                                     users#show {:format=>"json"}
#                                              PATCH  /api/users/:id(.:format)                                                                     users#update {:format=>"json"}
#                                              PUT    /api/users/:id(.:format)                                                                     users#update {:format=>"json"}
#                              user_deactivate DELETE /api/users/:id(.:format)                                                                     users#deactivate {:format=>"json"}
#                                      profile GET    /api/profile(.:format)                                                                       users#profile {:format=>"json"}
#                                              GET    /(*path)(.:format)                                                                           application#app
#                           rails_service_blob GET    /rails/active_storage/blobs/:signed_id/*filename(.:format)                                   active_storage/blobs#show
#                    rails_blob_representation GET    /rails/active_storage/representations/:signed_blob_id/:variation_key/*filename(.:format)     active_storage/representations#show
#                           rails_disk_service GET    /rails/active_storage/disk/:encoded_key/*filename(.:format)                                  active_storage/disk#show
#                    update_rails_disk_service PUT    /rails/active_storage/disk/:encoded_token(.:format)                                          active_storage/disk#update
#                         rails_direct_uploads POST   /rails/active_storage/direct_uploads(.:format)                                               active_storage/direct_uploads#create
#

Rails.application.routes.draw do
  devise_for :users, class_name: 'ApiUser', skip: :all
  scope path: 'api', defaults: { format: 'json' } do
    
    devise_scope :user do
      post    'login',        to: 'devise_api/sessions#create'
      delete  'logout',       to: 'devise_api/sessions#destroy'
    end

    resources :coffee_shops, only: [:create, :update, :show, :index, :destroy] do
      resources :board_games, only: [:create, :update, :show, :index, :destroy]
      resources :events, only: [:create, :update, :show, :index, :destroy] do
        resources :tables, only: [:create, :update, :show, :index, :destroy] do
          resources :enrolments, only: [:create, :index, :destroy]
        end
      end
    end 
    
    resources :users, only:[:create, :update, :show, :index, :destroy]
    get '/profile', to: 'users#profile'
  end

  get '(*path)', to: 'application#app'
end
