class ApiController < ApplicationController
  before_filter :load_currencies

  def nbg
    params[:currency] ||= 'USD'



# description: return the list of exchange rates for the provided currencies; if dates provided limit scope to just those dates
# input: list of currencies (max of 5), start date (optional), end date (optional)
# output: array of dates, hash of currency results: {currency: {name: ____, rates: []}


    errors = []
    start_date = nil
    end_date = nil

    if params[:start_date].present? && params[:end_date].present?
      begin  
        start_date = params[:start_date].to_i 
        if start_date > 0
          start_date = Time.at(start_date/1000.0)
        else
          raise
        end  
      rescue  
        errors.push({ field: 'start_date', message: 'Start date field is invalid.' })
      end  

      begin  
        end_date = params[:end_date].to_i 
        if end_date > 0
          end_date = Time.at(end_date/1000.0)
        else
          raise
        end  
      rescue  
        errors.push({ field: 'end_date', message: 'End date field is invalid.' })
      end  
    end

    data = { valid: true, result: []}
    result = []
    @currencies = Currency.data
    flag = false
    params[:currency].split(',').each{|cur_item|
      if @currency_codes.index(cur_item) != nil
        cur = @currencies.select{|c| c[0] == cur_item }.first
        x = Rate.nbg_rates(cur_item,start_date,end_date)
        if x.present?
          result << {code: cur[0], name: cur[1], ratio: cur[2], rates: x}
          flag = true
        end
      else
        errors.push({ field: 'currency', message: 'Currency ' + cur_item + ' is not exist' })
      end
    }
    if !flag 
      errors.push({ field: 'currency', message: 'Missing currency field' })
    end


    if(errors.any?)
      data['errors'] = errors
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

    errors = []
    start_date = nil
    end_date = nil

    if params[:start_date].present? && params[:end_date].present?
      begin  
        start_date = params[:start_date].to_i 
        if start_date > 0
          start_date = Time.at(start_date/1000.0)
        else
          raise
        end  
      rescue  
        errors.push({ field: 'start_date', message: 'Start date field is invalid.' })
      end  

      begin  
        end_date = params[:end_date].to_i 
        if end_date > 0
          end_date = Time.at(end_date/1000.0)
        else
          raise
        end  
      rescue  
        errors.push({ field: 'end_date', message: 'End date field is invalid.' })
      end  
    end

    data = { valid: true, result: []}
    result = []

    #cur = Currency.find_by_code(currency)

    if @currency_codes.index(currency) != nil && bank.any?
      bank.each{|code|
        b = Bank.find_by_code(code)            
          if b.id == 1
            x = Rate.rates_nbg(currency, b.id)
            if x.present?
              result << { id: code + '_' + currency, name:  (b.name + " (" + b.code + ")"), data: x, color: b.buy_color }
            end
          else
            x = Rate.rates_buy(currency, b.id)
            if x.present?
              result << { id: code + '_' + currency + '_B' , name: (b.name + " " +  t('app.common.buy') + " (" + b.code + ")"), data: x, color: b.buy_color, dashStyle: 'shortdot' }
            end
            x = Rate.rates_sell(currency, b.id)
            if x.present?
              result << { id: code + '_' + currency + '_S', name:  (b.name + " " +  t('app.common.sell') +  " (" + b.code + ")"), data: x, color: b.sell_color, dashStyle: 'shortdash' }
            end
          end
        
      }
    end

    if(errors.any?)
      data['errors'] = errors
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

    errors = []
    begin  
      date_start = params[:date_start].to_i 
      if date_start > 0
        date_start = Time.at(date_start/1000.0)
      else
        raise
      end  
    rescue  
      errors.push({ field: 'date_start', message: 'From date field is invalid.' })
    end  

    begin  
      date_end = params[:date_end].to_i 
      if date_end > 0
        date_end = Time.at(date_end/1000.0)
      else
        raise
      end  
    rescue  
      errors.push({ field: 'date_end', message: 'To date field is invalid.' })
    end  

     data = { amount: amount, valid: true }
     errors.push({ field: 'amount', message: 'Amount should be greater than 0.' }) if(amount <= 0)
     errors.push({ field: 'cur', message: 'Currency field is not valid.' }) if(@currency_codes.index(cur) == nil)
     errors.push({ field: 'dir', message: 'Converting direction field can be 0 or 1, 1 means GEL -> USD, 0: USD -> GEL.' }) if(dir == 0 || dir == 1)


    if(errors.any?)
      data['errors'] = errors
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
    @currency_codes = Currency.pluck(:code)
  end
end
