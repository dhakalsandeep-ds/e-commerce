Rails.application.routes.draw do
  get "search/show"
  # resource :session
  # resources :passwords, param: :token
  # namespace :dashboard do
  #   get "campaigns/index"
  #   get "campaigns/show"
  #   get "campaigns/new"
  #   get "campaigns/create"
  #   get "campaigns/edit"
  #   get "campaigns/update"
  #   get "campaigns/destroy"
  #   get "automations/index"
  #   get "automations/show"
  #   get "automations/new"
  #   get "automations/create"
  #   get "automations/edit"
  #   get "automations/update"
  #   get "automations/destroy"
  #   get "discounts/index"
  #   get "discounts/show"
  #   get "discounts/new"
  #   get "discounts/create"
  #   get "discounts/edit"
  #   get "discounts/update"
  #   get "discounts/destroy"
  # end
  # =========================
  # App routes
  # =========================

    get "/search", to: "search#show", as: :search


  get "/placeholder", to: "placeholders#show"
post "/contact", to: "contact_messages#create"
  # -- Non-namespaced routes (public/storefront)
  scope module: :storefront do
    root to: "landing_page#index"

    # Shop
    get '/shop', to: 'store#index', as: 'shop'
    get '/shop/products/:id', to: 'store#show', as: 'shop_product'
    get '/shop/collections/:handle', to: 'store#smart_collection', as: 'shop_smart_collection'

    # Pages
    get 'about', to: 'pages#about'
   get 'checkout/show', to: 'checkout#show', as: 'checkout_show'
  post 'checkout/create', to: 'checkout#create', as: 'checkout_create'
  get 'checkout/success', to: 'checkout#success', as: 'checkout_success'
   get 'checkout/cancel', to: 'checkout#cancel', as: 'checkout_cancel'
    get 'privacy', to: 'pages#privacy'
    get 'terms', to: 'pages#terms'
    get 'contact', to: 'pages#contact'
    # get '/checkout', to: 'orders#new', as: 'checkout'

    # User dashboard (nested resources)
    resource :user_dashboard, only: [ :show ] do
      resources :orders, only: [ :index, :show ], controller: 'user_dashboard/orders'
      resource :profile, only: [ :show, :edit, :update ], controller: 'user_dashboard/profile'
      resource :address, only: [ :show, :edit, :update ], controller: 'user_dashboard/address'
    end

    # Cart & Products
    resources :cart_items, only: [ :create, :update, :destroy ]
    resources :products, only: [ :index, :show ]
    resources :categories, only: [ :index, :show ]
    resource :cart, only: [ :show, :update, :destroy ]
   resources :orders, only: [:create, :show]

get '/orders/:id/success',
    to: 'orders#success',
    as: :order_success

get '/orders/:id/cancel',
    to: 'orders#cancel',
    as: :order_cancel
  end

  # -- Namespaced routes (dashboard/admin)
  namespace :dashboard do 
      resources :option_types do
    resources :option_values, only: [ :new, :create, :destroy ]
  end
resources :user_interactions
    root to: 'landing_page#index'
    resources :collections do
      collection { post :preview }
    end

    resources :orders
    resources :products do
      collection { post :bulk_action }
    end
    resources :users   do 
      collection do
      post :run_kmeans
      post :clear_customer_groups
    end
  end

     resources :customer_groups, only: [:index] 

    resources :categories 
    resources :discounts 
    resources :automations 
    resources :campaigns
    
    # root ''
    get 'reports', to: 'reports#index'
  end


  devise_for :users,
  only: [:sessions, :registrations],
  controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }


   
  mount ActiveStorage::Engine => '/rails/active_storage'
  get 'up', to: 'rails/health#show'

  # Payments
  get 'payments', to: 'payments#index'
  post '/payments/pay', to: 'payments#pay'
  post '/payments/esewa/success', to: 'payments#success', as: :payments_esewa_success
  post '/payments/esewa/failure', to: 'payments#failure', as: :payments_esewa_failure
end
