class Api::V1Controller < ApplicationController
  before_filter :load_currencies, except: [:index, :documentation]
  after_filter :record_analytics, except: [:index, :documentation]

  def index
    redirect_to api_path
  end

  def documentation
    redirect = false
    redirect = params[:method].nil?

    if !redirect
      v = request.path.split('/')[3]
      m = request.path.split('/').last
      # see if version exists
      @api_version = ApiVersion.is_public.by_permalink(v)
      # see if method exists
      @api_method = ApiMethod.is_public.by_permalink(@api_version.id, m) if @api_version.present?

      redirect = @api_method.nil?
    end

    if redirect
      redirect_to api_path, :notice => t('app.msgs.does_not_exist')
    else
      @tab='api'
      @css.push('shCore.css', 'shThemeDefault.css', 'api.css')
      @js.push('shCore.js', 'shBrushJScript.js', 'api.js')

      respond_to do |format|
        format.html {render 'api/documentation'}
      end
    end
  end

  ###########################
  ###########################

  # get list of currencies tracked by NBG
  # start/end date are optional
  def nbg_currencies
    data = { valid: true}
    template = {code: nil, name: nil}
    @errors = []

    start_date = to_date('start_date', true)
    end_date = to_date('end_date', true)
    validate_dates(start_date, end_date)

    if @errors.any?
      data[:errors] = @errors
      data[:valid] = false
    else
      data[:results] = []
      nbg_currencies = Rate.nbg_currencies.by_period(start_date, end_date).map{|x| x.currency}
      currencies = Currency.data

      # for each currency, if in nbg add to result
      currencies.each do |currency|
        if nbg_currencies.index{|x| x == currency[0]}.present?
          c = template.clone
          c[:code] = currency[0]
          c[:name] = currency[1]
          c[:ratio] = currency[2]
          data[:results] << c
        end
      end
    end

    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end


  # get list of exchange rates from NBG for one or more currency
  # required params: currency
  # optional params: start_date, end_date
  def nbg_rates
    data = { valid: true } # assume that at start it is failing
    # http://localhost:3000/en/api/v1/nbg_rates?currency=EUR&start_date=1461758741831&end_date=1457870734966
    params[:currency] ||= 'USD'
    flag = true
    @errors = []
    start_date = to_date('start_date', true)
    end_date = to_date('end_date', true)
    validate_dates(start_date, end_date)

    if !@errors.any?
      result = []
      @currencies = Currency.data
      flag = false

      params[:currency].split(',').each{|cur_item|
        if @currency_codes.has_key?(cur_item)
          cur = @currencies.select{|c| c[0] == cur_item }.first
          x = Rate.nbg_rates(cur_item,{from: start_date,to: end_date})
          if x.present?
            result << {code: cur[0], name: cur[1], ratio: cur[2], rates: x}
            flag = true
          end
        else
          error("currency_does_not_exist", { pars: [cur_item]})
        end
      }
    end

    if !flag
      error("missing_data_currency")
    end


    if @errors.any?
      data['errors'] = @errors
      data['valid'] = false
    else
      data['result'] = result
    end

    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end




  # get list of commercial banks
  def commercial_banks
    data = { valid: true }
    template = {code: nil, name: nil, currencies: nil}

    data[:results] = []
    banks = Bank.not_nbg.sorted
    bank_currencies = Rate.currency_by_bank
    currencies = Currency.data

    # for each bank, add code, name and currencies
    data[:results] = []
    banks.each do |bank|
      b = template.clone
      b[:code] = bank.code
      b[:name] = bank.name

      # now add all of the bank currencies
      b[:currencies] = []
      bank_currencies.select{|x| x.bank_id == bank.id}.each do |currency|
        b[:currencies] << currency.currency
      end

      data[:results] << b
    end


    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end


  # get list of commercial banks with currency
  # required params: currency
  def commercial_banks_with_currency
    params[:currency] ||= 'USD'
    data = { valid: true }
    template = {code: nil, name: nil}
    @errors = []

    currency = Currency.by_code(params[:currency])

    if currency.blank?
      error("currency_not_recognized")
    end

    if @errors.any?
      data['errors'] = @errors
      data['valid'] = false
    else
      data[:results] = []
      banks = Bank.not_nbg.sorted
      bank_currencies = Rate.currency_by_bank
      banks_with_currency = bank_currencies.select{|x| x.currency == currency.code}.map{|x| x.bank_id}.uniq

      # for each bank, add code, name and currencies
      data[:results] = []
      banks.each do |bank|
        if banks_with_currency.index{|x| x == bank.id}.present?
          b = template.clone
          b[:code] = bank.code
          b[:name] = bank.name

          data[:results] << b
        end
      end
    end

    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end



  # get the exchange rates for commercial banks for a currency
  # required params: currency, bank_id(s)
  # optional params: start_date, end_date
  def commercial_bank_rates
    currency = params[:currency].present? ? params[:currency].upcase : nil
    banks = params[:bank].present? ? params[:bank].split(',').map{|x| x.upcase } :  Bank.all.map{|x| x.code }

    @errors = []
    if params[:bank].present?
      bbs = []
      banks.each{ |t|
        bbs << t if Bank.find_by_code(t).nil?
      }      
      error("bank_not_found", { pars: [bbs.join(", ")]})  if bbs.present?      
    end
    start_date = params[:start_date].present? ? to_date('start_date') : nil
    end_date =  params[:end_date].present? ? to_date('end_date') : nil


    data = { valid: true }
    result = []

    if !@currency_codes.has_key?(currency)
      error("currency_not_recognized")
    end
    validate_dates(start_date, end_date)

    if !@errors.any?
      ratio = @currency_codes[currency]
      if ratio != nil && banks.any?
        banks.each{|code|
          b = Bank.find_by_code(code)
            if b.id == 1
              x = Rate.rates_nbg(currency, b.id)
              if x.present?
                result << { id: code + '_' + currency, code: code, name:  (b.name + " (" + b.code + ")"), currency: currency, rate_type: 'reference', color: b.buy_color, legendIndex: b.order+1, data: x }
              end
            else
              x = Rate.rates_buy(currency, b.id, ratio)
              if x.present?
                result << { id: code + '_' + currency + '_B' , code: code, name: (b.name + " " + " (" + b.code + ")"), currency: currency, rate_type: 'buy', color: b.buy_color, dashStyle: 'shortdot', legendIndex: 2*b.order, data: x }
              end
              x = Rate.rates_sell(currency, b.id, ratio)
              if x.present?
                result << { id: code + '_' + currency + '_S', code: code, name: (b.name + " " + " (" + b.code + ")"), currency: currency, rate_type: 'sell', color: b.sell_color, dashStyle: 'shortdash', legendIndex: 2*b.order+1, data: x }
              end
            end

        }
      end
    end

    if @errors.any?
      data['errors'] = @errors
      data['valid'] = false
    else
      data['result'] = result
    end

    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end


  # calcualte the change in amount value over time
  # required params: amount, currency, direction, start_date, end_date
  def calculator
    amount = params[:amount].to_f
    cur = params[:currency].present? ? params[:currency].upcase : nil
    dir = params[:direction] ||= 0

    @errors = []
    start_date = to_date('start_date')
    end_date = to_date('end_date')

    data = { valid: true }
    error("greater_than_zero") if(amount <= 0)
    error("currency_not_recognized") if(!@currency_codes.has_key?(cur))
    error("currency_directions") if !(dir == '0' || dir == '1')
    validate_dates(start_date, end_date)

    # convert direction to int
    dir = dir.to_i

    if @errors.any?
      data['errors'] = @errors
      data['valid'] = false
    else
      rates = Rate.nbg_rates(cur, {from: start_date, to: end_date})

      data[:currency] = {from: dir == 1 ? "GEL" : "#{cur}", to: dir == 1 ? "#{cur}" : "GEL"}
      data[:dates] = {start: {utc: rates.first[0], date: start_date}, end: {utc: rates.last[0], date: end_date}}
      if dir == 1 # gel -> currency
        data[:rates] = {start: 1/rates.first[1], end: 1/rates.last[1]}
      else # currency -> gel
        data[:rates] = {start: rates.first[1], end: rates.last[1]}
      end
      data[:amounts] = {original: amount, start: data[:rates][:start] * amount, end: data[:rates][:end] * amount}
      data[:amounts][:difference] = data[:amounts][:end] - data[:amounts][:start]
    end

    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end

  def errors
    data = { valid: true, results: [] }

    ERRORS.each do |e|
      name = e[:name]
      message = nil
      if e[:message].present?
        message = e[:message]
      elsif e[:pars].present? && e[:pars].length > 0 && e[:sample].present? && e[:pars].length == e[:sample].length
        opts = {}
        e[:pars].each_with_index {|d,i|
          opts[d] = e[:sample][i]
        }
        message = t("#{MSG_PATH}#{name}", opts)
      else
        message = t("#{MSG_PATH}#{name}")
      end

      data[:results] << {
                          code: e[:code],
                          # name: name,
                          field: e[:field].present? ? e[:field] :nil,
                          message: message
                        }
    end

    respond_to do |format|
      format.json { render json: data, :callback => params[:callback] }
    end
  end


private

  def load_currencies
    @currency_codes =  Hash[Currency.select('code,ratio').map { |t|  [t.code, t.ratio] }]
  end

  # convert utc date to normal date
  def to_date(p,r=false) # if r true then will add error
    begin
      v = params[p].to_i
      if v > 0
        v = Time.at(v/(v.to_s.length > 10 ? 1000.0 : 1.0)).to_date
      else
        raise
      end
    rescue
      error("invalid_field", { field: p, pars: [p.humanize]}) if !r
      nil
    end
  end

  # make sure the start and end dates are ok
  # - start < end
  # - start year > 2000
  def validate_dates(start_date, end_date)
    if start_date.present? && end_date.present?
      if end_date < start_date
        error("start_less_then_end_date")
        #@errors.push({ field: 'dates', message: t('app.msgs.start_less_then_end_date') })
      end

      if start_date.year < 2000
        error("start_date_start_point")
        #@errors.push({ field: 'start_date', message: t('app.msgs.start_date_start_point') })
      end
    end
  end

  # record call to google analytics
  def record_analytics
    if Rails.env.production?
      ga_id = 'UA-12801815-42'
      domain = 'lari.jumpstart.ge'

      g = Gabba::Gabba.new(ga_id, domain)
      g.referer(request.env['HTTP_REFERER'])
      g.ip(request.remote_ip)
      # page view format is (title, url)
      g.page_view("api:v1:#{params[:action]}", request.fullpath)
    end
  end
  ERRORS = [
  # General errors
    {
      code: 1000,
      name: "general_error",
      #message: "Undocumented error"
    },
    {
      code: 1001,
      name: "invalid_field",
      pars: [:obj],
      sample: ["[Object]"]
    },
  # Field specific errors
    {
      code: 2001,
      name: "currency_does_not_exist",
      field: 'currency',
      pars: [:obj],
      sample: ["[USK]"]
    },
    {
      code: 2002,
      name: "missing_data_currency",
      field: 'currency',
    },
    {
      code: 2003,
      name: "currency_not_recognized",
      field: 'currency',
    },
    {
      code: 2004,
      name: "bank_not_found",
      field: 'banks',
      pars: [:obj],
      sample: ["[BAGO]"]
    },
  # Field validation errors
    {
      code: 2501,
      name: "greater_than_zero",
      field: 'amount',
    },
    {
      code: 2502,
      name: "currency_directions",
      field: 'direction',
    },
    {
      code: 2503,
      name: "start_less_then_end_date",
      field: 'start_date,end_date',
    },
    {
      code: 2504,
      name: "start_date_start_point",
      field: 'start_date',
    },
  ]
  MSG_PATH = "app.msgs."

  def error(name, options = {})
    # options = { field: 'string', pars: []}
    begin

      # if name != "error"
      #   raise 'An error has occured'
      # end

      has_error = false
      meta = ERRORS.select {|x| x[:name] == name }
      if(meta.length == 1)

        meta = meta[0]
        code = meta[:code]
        field = nil
        message = nil

        if meta[:field].present?
          field = meta[:field]
        elsif options[:field].present?
          field = options[:field]
        else
          has_error = true
        end

        if meta[:message].present?
          message = meta[:message]
        elsif meta[:pars].present? && meta[:pars].length > 0 && options[:pars].present? && meta[:pars].length == options[:pars].length
          opts = {}
          meta[:pars].each_with_index {|d,i|
            opts[d] = options[:pars][i]
          }
          message = t("#{MSG_PATH}#{name}", opts)
        else
          message = t("#{MSG_PATH}#{name}")
        end

        @errors.push({ code: code, field: field, message: message })

        has_error = false
      end
      error("general_error") if has_error
    rescue
      error("general_error")
    end
  end
end
