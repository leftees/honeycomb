Rails.application.routes.draw do

  devise_for :users, controllers: { cas_sessions: 'simple_cas' }

  root :to => 'collections#index'

  get 'help', to: 'help#help'

  get '404', to: 'errors#catch_404'
  get '500', to: 'errors#catch_500'

  resource :masquerades, :only => [:new, :create] do
    get :cancel
  end

  resources :errors

  resources :collections, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
    get :exhibit

    resources :items, only: [:index, :new, :create]

    resources :editors, only: [:index, :create, :destroy] do
      collection do
        get :user_search
      end
    end
  end

  resources :items, only: [ :edit, :update, :destroy ] do
    member do
      put :publish
      put :unpublish
    end
    resources :children, controller: 'item_children', only: [ :new, :create]
  end

  resources :exhibits, only: [ :show, :edit, :update ] do
    resources :showcases, only: [:index, :new, :create ]
  end

  resources :showcases, only: [ :show, :edit, :update, :destroy ] do
    member do
      get :title
      put :publish
      put :unpublish
    end
    resources :sections, only: [:index, :new, :create ]
  end

  resources :sections, only: [:edit, :update, :destroy ]


  namespace :v1 do
    resources :collections, only: [:show, :index], defaults: {format: :json} do
      resources :items, only: [:index], defaults: {format: :json}
      resources :showcases, only: [:index], defaults: {format: :json}
    end
    resources :items, only: [:show], defaults: {format: :json}
    resources :showcases, only: [:show], defaults: {format: :json}
    resources :sections, only: [:show], defaults: {format: :json}
  end

  namespace :api do
    resources :collections, only: [:index, :show], constraints: {format: /json/} do
      resources :items, only: [:index, :show], constraints: {format: /json/}
    end
  end

  namespace :admin do
    resources :administrators, only: [:index, :create, :destroy] do
      collection do
        get :user_search
      end
    end
  end

  scope '/admin_old' do
    resources :users do
      put :set_admin
      put :revoke_admin
    end

    # NOTE About this route.
    # the "ids" that are searched on can have "." in them and that throws off the rails routing. They need to be passed in as
    # query params and not as part of the get string that is not /discovery_test_id/i,adf.adsfwe.adsfsdf but as /discovery_test_id?id=i,adf.adsfwe.adsfsdf
    get "discovery_id_test", to: 'discovery_id_test#show'
  end
end
