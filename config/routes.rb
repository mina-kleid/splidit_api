Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'
  resources :beta_users, only: [:new, :create] do
    get "success" => "beta_users#success", on: :collection
  end

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

      resources :transactions, only: [:index]

      resources :conversations, :except => [:new,:edit,:destroy] do
        resources :conversation_posts,path: 'posts', :only => [:create, :index]
        resources :conversation_transactions,path: 'transactions', :only => [:create, :index]
        resources :conversation_requests,path: 'requests', :only => :create do
          member do
            post "accept" => "conversation_requests#accept"
            post "reject" => "conversation_requests#reject"
          end
        end
      end

      resources :bank_accounts, path: 'accounts', :except => [:new,:edit,:destroy] do
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
