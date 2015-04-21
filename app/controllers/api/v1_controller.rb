class Api::V1Controller < ApplicationController
  before_filter :load_currencies, except: [:index, :documentation]

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
      @tab=4
      @css.push('shCore.css', 'shThemeDefault.css', 'api.css')
      @js.push('shCore.js', 'shBrushJScript.js', 'api.js')

      respond_to do |format|
        format.html {render 'api/documentation'}
      end
    end
  end

  ###########################
  ###########################

  def nbg
    params[:currency] ||= 'USD'

# description: return the list of exchange rates for the provided currencies; if dates provided limit scope to just those dates
# input: list of currencies (max of 5), start date (optional), end date (optional)
# output: array of dates, hash of currency results: {currency: {name: ____, rates: []}


    @errors = []
    start_date = to_time('start_date', true)
    end_date = to_time('end_date', true)

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
        @errors.push({ field: 'currency', message: 'Currency ' + cur_item + ' is not exist' })
      end
    }
    if !flag 
      @errors.push({ field: 'currency', message: 'Missing data for currency' })
    end

    if(@errors.any?)
      data['errors'] = @errors
      data['valid'] = false
    else    
      data['result'] = result
    end

    respond_to do |format|
      format.json { render json: data }
    end
  end


  def rates
    currency = params[:currency]
    bank =  Bank.with_translations(:en).map{|x| x.code } & params[:bank].split(',')

    @errors = []
    start_date = params[:start_date].present? ? to_time('start_date') : nil
    end_date =  params[:end_date].present? ? to_time('end_date') : nil


    data = { valid: true, result: []}
    result = []

    ratio = @currency_codes[currency]
    if ratio != nil && bank.any?
      bank.each{|code|
        b = Bank.find_by_code(code)            
          if b.id == 1
            x = Rate.rates_nbg(currency, b.id)
            if x.present?
              result << { id: code + '_' + currency, name:  (b.name + " (" + b.code + ")"), data: x, color: b.buy_color, code: code, legendIndex: b.order+1 }
            end
          else
            x = Rate.rates_buy(currency, b.id, ratio)
            if x.present?
              result << { id: code + '_' + currency + '_B' , name: (b.name + " " + " (" + b.code + ")"), data: x, color: b.buy_color, dashStyle: 'shortdot', rate_type: 'buy', code: code, legendIndex: 2*b.order }
            end
            x = Rate.rates_sell(currency, b.id, ratio)
            if x.present?
              result << { id: code + '_' + currency + '_S', name:  (b.name + " " + " (" + b.code + ")"), data: x, color: b.sell_color, dashStyle: 'shortdash', rate_type: 'sell', code: code, legendIndex: 2*b.order+1 }
            end
          end
        
      }
    end

    if(@errors.any?)
      data['errors'] = @errors
      data['valid'] = false
    else    
      data['result'] = result
    end

    respond_to do |format|
      format.json { render json: data }
    end
  end


  def calculator
    amount = params[:amount].to_f
    cur = params[:currency]
    dir = params[:direction]     

    @errors = []
    date_start = to_time('date_start')
    date_end = to_time('date_end')


    data = { amount: amount, valid: true }
    @errors.push({ field: 'amount', message: 'Amount should be greater than 0.' }) if(amount <= 0)
    @errors.push({ field: 'cur', message: 'Currency field is not valid.' }) if(@currency_codes.index(cur) == nil)
    @errors.push({ field: 'dir', message: 'Converting direction field can be 0 or 1, 1 means GEL -> Currency, 0: Currency -> GEL.' }) if(dir == 0 || dir == 1)


    if(@errors.any?)
      data['errors'] = @errors
      data['valid'] = false
    else
      rates = Rate.nbg_rates(cur, date_start, date_end)

      data['currency_from'] = dir == 1 ? "GEL" : "#{cur}"
      data['currency_to'] = dir == 1 ? "#{cur}" : "GEL"

      data['date_start'] = rates.first[0]
      data['rate_start'] = rates.first[1]
      data['amount_start'] = data['rate_start'] * amount

      data['date_end'] = rates.last[0]
      data['rate_end'] = rates.last[1]
      data['amount_end'] = data['rate_end'] * amount

      data['amount_diff'] = data['amount_end'] - data['amount_start']

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

  def to_time(p,r) # if r true then will add error
    begin
      v = params[p].to_i
      if v > 0
        v = Time.at(v/(v.to_s.length > 10 ? 1000.0 : 1.0))
      else
        raise
      end  
    rescue  
      @errors.push({ field: p, message: p.humanize + ' field is invalid.' }) if !r
      nil
    end
  end
end