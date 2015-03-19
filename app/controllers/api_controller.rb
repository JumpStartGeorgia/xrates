class ApiController < ApplicationController

  def nbg
    params[:currency] ||= 'USD'

    rates = []

    @currencies = Currency.data 
    params[:currency].split(',').each{|x|
      if CURRENCIES.index(x) != nil
        cur = @currencies.select{|c| c[0] == x }.first
        x = Rate.utc_and_rates(x)
        if x.present?
          rates << {code: cur[0], name: cur[0] + ' - ' + cur[1], ratio: cur[2], data: x}
        end
      end      
    }
    respond_to do |format|
      format.json { render json: { :title => I18n.t('chart.nbg.title') , :rates => rates } }
    end
  end
  def rates
    currency = params[:currency]
    bank = BANKS & params[:bank].split(',')
    dt = []
    #cur = Currency.find_by_code(currency)

    if CURRENCIES.index(currency) != nil && bank.any?
      bank.each{|bid|
        b = Bank.find_by_id(bid)    
        x = Rate.rates_except_nbg(currency, bid)
        if x.present?
            dt << { name: b.name, data: x}
        end
      }
    end
    respond_to do |format|
      format.json { render json: { rates: dt } }
    end
  end
end
