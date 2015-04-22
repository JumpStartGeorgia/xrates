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

      match "/v1/nbg_currencies" => "v1#nbg_currencies", as: 'v1_nbg_currencies', :via => :get, :defaults => { :format => 'json' }
      match "/v1/nbg_rates" => "v1#nbg_rates", as: 'v1_nbg_rates', :via => :get, :defaults => { :format => 'json' }

      match "/v1/commercial_banks" => "v1#commercial_banks", as: 'v1_commercial_banks', :via => :get, :defaults => { :format => 'json' }
      match "/v1/commercial_banks_with_currency" => "v1#commercial_banks_with_currency", as: 'v1_commercial_banks_with_currency', :via => :get, :defaults => { :format => 'json' }
      match "/v1/commercial_bank_rates" => "v1#commercial_bank_rates", as: 'v1_commercial_bank_rates', :via => :get, :defaults => { :format => 'json' }

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
