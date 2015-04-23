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
      format.json { render json: data }
    end
  end


  # get list of exchange rates from NBG for one or more currency
  # required params: currency
  # optional params: start_date, end_date
  def nbg_rates
    params[:currency] ||= 'USD'

    @errors = []
    start_date = to_date('start_date', true)
    end_date = to_date('end_date', true)
    validate_dates(start_date, end_date)

    if !@errors.any?
      data = { valid: true, result: []}
      result = []
      @currencies = Currency.data
      flag = false

      params[:currency].split(',').each{|cur_item|
        if @currency_codes.has_key?(cur_item)
          cur = @currencies.select{|c| c[0] == cur_item }.first
          x = Rate.nbg_rates(cur_item,start_date,end_date)
          if x.present?
            result << {code: cur[0], name: cur[1], ratio: cur[2], rates: x}
            flag = true
          end
        else
          @errors.push({ field: 'currency', message: t('app.msgs.currency_does_not_exist', :obj => cur_item) })
        end
      }
    end

    if !flag 
      @errors.push({ field: 'currency', message: t('app.msgs.missing_data_currency') })
    end

    if @errors.any?
      data['errors'] = @errors
      data['valid'] = false
    else    
      data['result'] = result
    end

    respond_to do |format|
      format.json { render json: data }
    end
  end




  # get list of commerical banks
  def commercial_banks
    data = { valid: true}
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
      format.json { render json: data }
    end
  end


  # get list of commerical banks with currency
  # required params: currency
  def commercial_banks_with_currency
    params[:currency] ||= 'USD'
    data = { valid: true}
    template = {code: nil, name: nil}
    @errors = []

    currency = Currency.by_code(params[:currency])

    if currency.blank?
      @errors.push({ field: 'currency', message: t('app.msgs.currency_is_not_valid') })
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
      format.json { render json: data }
    end
  end



  # get the exchange rates for commerical banks for a currency
  # required params: currency, bank_id(s)
  # optional params: start_date, end_date
  def commercial_bank_rates
    currency = params[:currency].present? ? params[:currency].upcase : nil
    bank_codes = params[:bank].split(',').map{|x| x.upcase}
    bank =  Bank.with_translations(:en).map{|x| x.code } & bank_codes

    @errors = []
    start_date = params[:start_date].present? ? to_date('start_date') : nil
    end_date =  params[:end_date].present? ? to_date('end_date') : nil


    data = { valid: true}
    result = []

    if !@currency_codes.has_key?(currency)
      @errors.push({ field: 'currency', message: t('app.msgs.currency_not_recognized') })
    end
    validate_dates(start_date, end_date)

    if !@errors.any?
      ratio = @currency_codes[currency]
      if ratio != nil && bank.any?
        bank.each{|code|
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
      format.json { render json: data }
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
    @errors.push({ field: 'amount', message: t('app.msgs.greater_than_zero') }) if(amount <= 0)
    @errors.push({ field: 'currency', message: t('app.msgs.currency_is_not_valid') }) if(!@currency_codes.has_key?(cur))
    @errors.push({ field: 'direction', message: t('app.msgs.currency_directions') }) if !(dir == '0' || dir == '1')
    validate_dates(start_date, end_date)

    # convert direction to int
    dir = dir.to_i

    if @errors.any?
      data['errors'] = @errors
      data['valid'] = false
    else
      rates = Rate.nbg_rates(cur, start_date, end_date)

      data[:currency] = {from: dir == 1 ? "GEL" : "#{cur}", to: dir == 1 ? "#{cur}" : "GEL"}
      data[:dates] = {start: {utc: rates.first[0], date: start_date}, end: {utc: rates.last[0], date: end_date}}
      if dir == 1 # gel -> currency
        data[:rates] = {start: 1/rates.first[1], end: 1/rates.last[1]} 
      else # currency -> gel
        data[:rates] = {start: rates.first[1], end: rates.last[1]} 
      end
      data[:amounts] = {original: amount, start: data[:rates][:start] * amount, end: data[:rates][:end] * amount}
      data[:amounts][:difference] = data[:amounts][:end] - data[:amounts][:start]

      #data['start_amount'] = rates.first
      #result = { }
      # get rates for period
      # get first and last row
      # process dir field
      # calculate result based on amount
      #return result
      #result['rates'] = rates
      #data['result'] = result
    end

    respond_to do |format|
      format.json { render json: data }
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
      @errors.push({ field: p,  message: t('app.msgs.invalid_field', :obj => p.humanize) }) if !r
      nil
    end
  end

  # make sure the start and end dates are ok
  # - start < end
  # - start year > 2000
  def validate_dates(start_date, end_date)
    if start_date.present? && end_date.present?
      if end_date < start_date
        @errors.push({ field: 'dates', message: t('app.msgs.start_less_then_end_date') })
      end

      if start_date.year < 2000
        @errors.push({ field: 'start_date', message: t('app.msgs.start_date_start_point') })
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
  

end