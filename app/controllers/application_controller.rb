class ApplicationController < ActionController::Base
	require 'will_paginate/array'
  protect_from_forgery

	before_filter :set_locale
	before_filter :is_browser_supported?
	before_filter :preload_global_variables
	before_filter :initialize_gon
	before_filter :store_location

	unless Rails.application.config.consider_all_requests_local
		rescue_from Exception,
		            :with => :render_error
		rescue_from ActiveRecord::RecordNotFound,
		            :with => :render_not_found
		rescue_from ActionController::RoutingError,
		            :with => :render_not_found
		rescue_from ActionController::UnknownController,
		            :with => :render_not_found
		rescue_from ActionController::UnknownAction,
		            :with => :render_not_found

    rescue_from CanCan::AccessDenied do |exception|
      redirect_to root_url, :alert => exception.message
    end
	end

	Browser = Struct.new(:browser, :version)
	SUPPORTED_BROWSERS = [
		Browser.new("Chrome", "15.0"),
		Browser.new("Safari", "4.0.2"),
		Browser.new("Firefox", "10.0.2"),
		Browser.new("Internet Explorer", "9.0"),
		Browser.new("Opera", "11.0")
	]

	def is_browser_supported?
		user_agent = UserAgent.parse(request.user_agent)
logger.debug "////////////////////////// BROWSER = #{user_agent}"
#		if SUPPORTED_BROWSERS.any? { |browser| user_agent < browser }
#			# browser not supported
#logger.debug "////////////////////////// BROWSER NOT SUPPORTED"
#			render "layouts/unsupported_browser", :layout => false
#		end
	end


	def set_locale
    if params[:locale] and I18n.available_locales.include?(params[:locale].to_sym)
      I18n.locale = params[:locale]
    else
      I18n.locale = I18n.default_locale
    end
	end

  def default_url_options(options={})
    { :locale => I18n.locale }
  end

	def preload_global_variables
    # indicate that whether login should allow local and omniauth or just locale
	  @enable_omniauth = false
    @css = []
    @js = []

    @last_scrapped_at = Rate.maximum(:updated_at).in_time_zone
 end

	def initialize_gon
		gon.set = true
		gon.highlight_first_form_field = true

		if I18n.locale == :ka
		  gon.datatable_i18n_url = "/datatable_ka.txt"
		else
		  gon.datatable_i18n_url = ""
		end
      gon.app_name = ' | ' + t('app.common.app_name')
      gon.a_chart_title = t(".root.index.page1.chart.title")
      gon.info_gel = t(".root.index.calculator.info_gel").html_safe
      gon.info_usd = t(".root.index.calculator.info_usd").html_safe
      gon.increased = t(".root.index.calculator.increased").html_safe
      gon.decreased = t(".root.index.calculator.decreased").html_safe
      gon.rate = t(".root.index.rate")
      gon.monetary_value = t(".root.index.monetary_value")
      gon.buy = t('app.common.buy')
      gon.sell = t('app.common.sell')
      gon.gel = t('app.common.gel')
      gon.usd = t('app.common.usd')
      gon.m1 = t('app.common.m1')
      gon.m3 = t('app.common.m3')
      gon.m6 = t('app.common.m6')
      gon.y1 = t('app.common.y1')
      gon.all = t('app.common.all')
      gon.date = t('app.common.date')
      gon.highcharts_downloadPNG = t('highcharts.downloadPNG')
      gon.highcharts_downloadJPEG = t('highcharts.downloadJPEG')
      gon.highcharts_downloadPDF = t('highcharts.downloadPDF')
      gon.highcharts_downloadSVG = t('highcharts.downloadSVG')
      gon.downloadCSV = t('highcharts.downloadCSV')
      gon.highcharts_printChart = t('highcharts.printChart')
      gon.highcharts_contextButtonTitle = t('highcharts.contextButtonTitle')
      gon.commercial_banks = t('app.common.commercial_banks')
      gon.micro_finance = t('app.common.micro_finance')
      gon.currencies = Currency.data
      gon.buying_gel = t('root.index.commercial.convertor.buying_gel')
      gon.buying_amount = t('root.index.commercial.convertor.buying_amount')
      currency_by_bank = {}
      Rate.currency_by_bank.each{|t|
         if(currency_by_bank.has_key?(t.currency))
            currency_by_bank[t.currency].push(t.bank_id)
         else
            currency_by_bank[t.currency] = [t.bank_id]
         end
      }
      gon.currency_to_bank = currency_by_bank.to_json
      gon.banks = Bank.all_except_nbg.each_with_index.map{|x,i| [ x[0], x[1], x[4], { :'data-image' => x[5] }, x[6] ] }

      gon.dev = Rails.env.development?
      #:title => I18n.t('chart.nbg.title') ,
	end

  # load the assets needed for the admin forms
  def load_admin_assets
    @css.push('admin.css', 'api.css', 'shCore.css', 'shThemeDefault.css')
    @js.push('admin.js', 'api.js', 'shCore.js', 'shBrushJScript.js')
  end

  # clean text for a file name
  def clean_filename(filename)
    filename.strip.latinize.to_ascii.gsub(' ', '_').gsub(/[\\ \/ \: \* \? \" \< \> \| \, \. ]/,'')
  end


	def after_sign_in_path_for(resource)
		session[:previous_urls].last || request.env['omniauth.origin'] || root_path(:locale => I18n.locale)
	end

  def valid_role?(role)
    redirect_to root_path, :notice => t('app.msgs.not_authorized') if !current_user || !current_user.role?(role)
  end

	# store the current path so after login, can go back
	# only record the path if this is not an ajax call and not a users page (sign in, sign up, etc)
	def store_location
		session[:previous_urls] ||= []
		if session[:previous_urls].first != request.fullpath &&
        params[:format] != 'js' && params[:format] != 'json' && !request.xhr? &&
        request.fullpath.index("/users/").nil?

	    session[:previous_urls].unshift request.fullpath
    elsif session[:previous_urls].first != request.fullpath &&
       request.xhr? && !request.fullpath.index("/users/").nil? &&
       params[:return_url].present?

      session[:previous_urls].unshift params[:return_url]
		end

		session[:previous_urls].pop if session[:previous_urls].count > 1
    #Rails.logger.debug "****************** prev urls session = #{session[:previous_urls]}"
	end

  # add in required content for translations if none provided
  # - if default locale does not have translations, use first trans that does as default
  def add_missing_translation_content(ary_trans)
    if ary_trans.present?
      default_trans = ary_trans.select{|x| x.locale == I18n.default_locale.to_s}.first

      if default_trans.blank? || !default_trans.required_data_provided?
        # default locale does not have data so get first trans that does have data
        ary_trans.each do |trans|
          if trans.required_data_provided?
            default_trans = trans
            break
          end
        end
      end

      if default_trans.present? && default_trans.required_data_provided?
        ary_trans.each do |trans|
          if trans.locale != default_trans.locale && !trans.required_data_provided?
            # add required content from default locale trans
            trans.add_required_data(default_trans)
          end
        end
      end
    end
  end



  #######################
	def render_not_found(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/404.html", :status => 404
	end

	def render_error(exception)
		ExceptionNotifier::Notifier
		  .exception_notification(request.env, exception)
		  .deliver
		render :file => "#{Rails.root}/public/500.html", :status => 500
	end

end
