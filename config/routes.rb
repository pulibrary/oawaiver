# frozen_string_literal: true

Rails.application.routes.draw do
  root to: "application#start"

  get("/start", to: "application#start", as: "start")
  get("/manage", to: "application#manage", as: "manage")
  get("/author_search_status", to: "application#author_search_status", as: "author_search_status")

  devise_for :accounts, controllers: { omniauth_callbacks: "accounts/omniauth_callbacks" }
  devise_scope :account do
    # This should be directing to account_cas_omniauth_authorize_path
    get("sign_in", to: "accounts/omniauth_callbacks#cas", defaults: { provider: :cas }, as: :new_account_session)
    # Deprecated
    get("login", to: "accounts/omniauth_callbacks#cas", defaults: { provider: :cas }, as: :login)

    delete("sign_out", to: "devise/sessions#destroy", as: :destroy_account_session)
    # Deprecated
    delete("logout", to: "devise/sessions#destroy", as: :logout)
  end

  unauthenticated do
    as :account do
      root to: "accounts/omniauth_callbacks#passthru", defaults: { provider: :cas }, as: :account_root
    end

    as :employee do
      root to: "accounts/omniauth_callbacks#passthru", defaults: { provider: :cas }, as: :employee_root
    end
  end

  resources :accounts, only: %i[new create destroy]

  get  "/waiver/requester/me",
       to: "waiver_infos#index_mine",
       as: "mine_waiver_infos"

  get  "/waiver/new",
       to: "waiver_infos#new",
       as: :new_waiver_info

  post  "/waiver/create",
        to: "waiver_infos#create",
        as: "create_waiver_info"

  get "/waiver/:id(.:format)",
      to: "waiver_infos#show",
      as: "waiver_info"

  get "/waiver/:id/mail",
      to: "waiver_infos#show_mail",
      as: "show_mail_waiver_info"

  get  "/admin/search",
       to: "waiver_infos#search",
       as: "search_waiver_infos",
       constraints: { format: /(html|json)/ }

  get  "/admin/waivers/match/:search_term",
       to: "waiver_infos#solr_search_words",
       as: "match_waiver_infos_get_words"
  get  "/admin/waivers/match",
       to: "waiver_infos#solr_search_words"
  post "/admin/waivers/match",
       to: "waiver_infos#solr_search_words_post",
       as: "match_waiver_infos_words"

  get  "/admin/waiver/:id",
       to: "waiver_infos#edit_by_admin",
       as: "edit_by_admin"
  post "/admin/waiver/:id",
       to: "waiver_infos#update_by_admin"

  get  "/admin/unique_id/:author_unique_id",
       to: "waiver_infos#index_unique_id",
       as: "index_unique_id_waiver_infos"

  get  "/admin/waivers",
       to: "waiver_infos#index",
       as: "waiver_infos"

  get "/admin/missing_unique_ids",
      to: "waiver_infos#index_missing_unique_ids",
      as: "index_missing_unique_ids_waiver_infos"

  # employee/author engine routes
  post "employees/search", to: "employees#search", as: "search_employees"
  get "employees/search/:search_term", to: "employees#search_get", as: "search_get_employees"
  get "employees/ajax_search/:style", to: "employees#ajax_search",
                                      defaults: { style: "form" },
                                      constraints: { style: /form|display/ }, as: "ajax_search_employees"

  get "employees/list/departments", to: "employees#index_departments", as: "index_departments"

  resources :employees, only: %i[index show]
  get "employees/get/:unique_id", to: "employees#get_uniqueId", as: "uniqueId_employee"

  # API+API Documentation
  mount API::Base => "/api"
  mount GrapeSwaggerRails::Engine => "/apidoc"

  unless Rails.env.development?
    # when not doing development, simply route any unrecognized get or post to start

    get("/*", to: "application#start")
    post("/*", to: "application#start")
  end

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
