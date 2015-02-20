Rails.application.routes.draw do

  devise_for :users, controllers: { cas_sessions: 'simple_cas' }

  root :to => 'collections#index'

  # person search
  get 'user_search', to: 'users#user_search'

  get '404', to: 'errors#catch_404'
  get '500', to: 'errors#catch_500'

  resource :masquerades, :only => [:new, :create] do
    get :cancel
  end

  resources :errors

  resources :collections, only: [:index, :show, :new, :create, :edit, :update, :destroy] do

    resources :items, only: [:index, :new, :create]

    resources :exhibits do
      resources :showcases do
        resources :sections
      end

      resources :items, only: [:index, :show], defaults: {format: :json}
    end
  end

  resources :items, only: [ :edit, :update, :destroy ] do
    resources :children, controller: 'item_children', only: [ :new, :create]
  end

  namespace :api do
    namespace :v1 do
      resources :collections, only: [:show], defaults: {format: :json} do
        resources :items, only: [:index, :show], defaults: {format: :json}
      end
    end

    resources :collections, only: [:index, :show], constraints: {format: /json/} do
      resources :items, only: [:index, :show], constraints: {format: /json/}
    end
  end

  scope '/admin' do
    post :set_curator, to: 'users#set_curator'
    post :remove_curator, to: 'users#remove_curator'
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
