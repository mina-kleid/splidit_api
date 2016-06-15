Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  namespace :api do
    namespace :v1 do
      get "test" => "test#test"
      get "test_api" => "test#test_api"
      resources :sessions, only: :create
      resources :users, :only => [:create] do
        collection do
          get "me" => "users#show"
          post "device_token" => "users#device_token"
          put "/" => "users#update"
        end
      end

      resources :contacts,:only => [] do
        collection do
          post "sync" => "contacts#sync"
        end

      end

      resources :conversations, :except => [:new,:edit,:destroy] do
        resources :conversation_posts, path: 'posts', :only => [:create, :index]
        resources :transactions, :only => :create
        resources :requests, :only => :create
        # post "transaction" => "conversations#transaction"
        # post "request" => "conversations#request"
      end

      resources :requests, :only =>[:index] do
        member do
          post "accept" => "requests#accept"
          post "reject" => "requests#reject"
        end

      end

      resources :bank_accounts, :except => [:new,:edit,:destroy] do
        member do
          post "withdraw" => "bank_accounts#withdraw"
          post "deposit" => "bank_accounts#deposit"
        end
      end
    end
  end
  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
