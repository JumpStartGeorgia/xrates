BootstrapStarter::Application.routes.draw do


	#--------------------------------
	# all resources should be within the scope block below
	#--------------------------------
	scope ":locale", locale: /#{I18n.available_locales.join("|")}/ do

		match '/admin', :to => 'admin#index', :as => :admin, :via => :get
		devise_for :users, :path_names => {:sign_in => 'login', :sign_out => 'logout'},
											 :controllers => {:omniauth_callbacks => "omniauth_callbacks"}

		namespace :admin do
      resources :page_contents
      resources :users
      resources :banks
      resources :api_versions, :except => [:show] do
        resources :api_methods, :except => [:index]
      end
		end

    # api
    match '/api', to: 'api#index', as: :api, via: :get
    namespace :api do
      match '/v1', to: 'v1#index', as: :v1, via: :get
      match '/v1/documentation(/:method)', to: 'v1#documentation', as: :v1_documentation, via: :get

      match "/v1/nbg" => "v1#nbg", as: 'v1_nbg', :via => :get, :defaults => { :format => 'json' }
      match "/v1/rates" => "v1#rates", as: 'v1_rates', :via => :get, :defaults => { :format => 'json' }
      match "/v1/calculator" => "v1#calculator", as: 'v1_calculator', :via => :get, :defaults => { :format => 'json' }
    end    
    
    # root pages
    match "about" => "root#about", as: 'about', :via => :get

		root :to => 'root#index'
	  match "*path", :to => redirect("/#{I18n.default_locale}") # handles /en/fake/path/whatever
	end

	match '', :to => redirect("/#{I18n.default_locale}") # handles /
	match '*path', :to => redirect("/#{I18n.default_locale}/%{path}") # handles /not-a-locale/anything

end
