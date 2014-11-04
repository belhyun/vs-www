VsWww::Application.routes.draw do
  resources :works

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'users#index'
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'
  get 'auth/vs', to: 'sessions#vs'
  get 'auth/signin', to: 'sessions#signin'
  get 'auth/logout', to: 'sessions#logout'
  get 'versions', to: 'versions#index'
  post 'errors/send_msg', to: 'errors#send_msg'

  resources :users do
    collection do
      post 'is_dup'
      post 'is_valid_user'
      post 'image'
      post 'bankruptcy'
      get 'work'
      post 'change_pwd'
      post 'change_nick'
    end
  end
  
  resources :gcms do
    collection do 
      post 'reg'
      post 'state'
      get 'send_msg'
      get 'show'
      post 'send_by_admin'
    end
  end

  resources :issues do
    collection do
      get 'open'
      get 'closed'
      get 'settle'
    end
  end

  resources :stocks do
    member do
      post 'buy'
      post 'sell'
    end
  end

  resources :ranks do
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
