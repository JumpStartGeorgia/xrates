class RootController < ApplicationController
  def index

    @js.push("u.js", "root.js") 
    @tab='calculator'
    
    params[:currency] ||= 'USD,EUR,GBP,RUB'
    params[:bank] ||= 'BNLN'    
    gon.currency = params[:currency]
    gon.bank = params[:bank]
    @currencies = Currency.data 
    @currencies_available = Currency.available
    @banks = Bank.all_except_nbg
    
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def about  
    @page_content = PageContent.by_name('about')

    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def data_download
    require 'csv'

    csv = nil
    currencies = nil
    filename = 'lari_explorer'
    @currencies = Currency.data
    
    case params[:type]
      when 'calculator'
        # params needed: amount, currency, direction, start_date, end_date
        # format: [date, currency rate, currency amount]
        # this is essential the same as 'national_bank', but with start/end dates and an extra column for the amount
        if params[:currency].present? && params[:amount].present? && params[:direction].present? && params[:start_date].present? && params[:end_date].present?
          rates = nil
          from = to_date(params[:start_date])
          to = to_date(params[:end_date])
         Rails.logger.debug("--------------------------------------------#{from}#{to}")
          amount = params[:amount].to_f
          direction = params[:direction] == "1" ? 1 : 0 # 1: GEL -> Currency, 0: Currency -> GEL
          currency = @currencies.select{|x| x[0] == params[:currency].upcase}.first

          if currency.present? && from.present? && to.present?
            from_currency = direction == 1 ? 'GEL' : currency[0]
            to_currency = direction == 1 ? currency[0] : 'GEL'

            rates = Rate.nbg_rates(params[:currency],{from: from, to: to, include_date: true})

            if rates.present?
              # create csv

              header = ['Date', "#{from_currency} to #{to_currency} Rate", "Amount (#{to_currency})"].flatten
              csv = CSV.generate do |csv_row|
                csv_row << header

                rates.each do |rate|
                  data_item = [rate[2]]

                  # get exchange rate for this date
                  # if direction = 1, then have to flip the rate
                  current_rate = rate[1]
                  if direction == 1
                    current_rate = 1/rate[1]
                  end

                  # add rate
                  data_item << current_rate


                  # add amount
                  data_item << amount * current_rate

                  csv_row << data_item
                end
              end

              filename << "__#{params[:type]}__#{amount}__#{from_currency}__#{params[:start_date].gsub('-','')}-#{params[:end_date].gsub('-','')}"
              filename << "__#{I18n.l Time.now, :format => :file_no_space}"
            end
          end
        end

      when 'national_bank'
        # params needed = currency
        # format: [date, currency1 rate, currency2 rate, ...]
        if params[:currency].present?
          rates = {}

          params[:currency].split(',').each{|cur_item|
            if @currencies.index{|x| x[0] == cur_item}.present?
              rates[cur_item] = Rate.nbg_rates(cur_item,{include_date: true})
            end
          }

          if rates.keys.present?
            # get the currencies that have data
            currencies = rates.keys

            # get the unique dates
            dates = rates.values.flatten(1).map{|x| [x[0], x[2]]}.uniq.sort

            # create csv
            header = ['Date', currencies].flatten
            csv = CSV.generate do |csv_row|
              csv_row << header
  
              # for each date, add currency exchange rate
              dates.each do |date|
                data_item = [date[1]]

                # get exchange rate for this date
                currencies.each do |currency|
                  header << currency
                  index = rates[currency].index{|x| x[0] == date[0]}
                  if index.present?
                    data_item << rates[currency][index][1]
                  else
                    data_item << nil
                  end
                end

                csv_row << data_item
              end
            end

            filename << "__#{params[:type]}__#{currencies.join(' ')}"
            filename << "__#{I18n.l Time.now, :format => :file_no_space}"
          end
        end

      when 'commercial_banks'
        # params needed = currency, bank
        # format: [date, bank1 buy rate, bank1 sell rate, ...]
         Rails.logger.debug("--------------------------------------------here")
        if params[:currency].present? && params[:bank].present?
          rates = {}
          filename_items = []

          if params[:currency].present?

            currency = @currencies.select{|x| x[0] == params[:currency].upcase}.first
            bank_codes = params[:bank].split(',').map{|x| x.upcase}
            banks =  Bank.all.map{|x| x.code } & bank_codes

            if currency.present? && banks.present?
              banks.each{|code|
                filename_items << code

                b = Bank.find_by_code(code)  

                key = b.name + ' - ' + currency[0]
                if b.id == 1
                  rates[key] = Rate.rates_nbg(currency[0], b.id, include_date: true)
                else
                  rates[key + ' - BUY'] = Rate.rates_buy(currency[0], b.id, currency[2], include_date: true)
                  rates[key + ' - SELL'] = Rate.rates_sell(currency[0], b.id, currency[2], include_date: true)
                end              
              }
            end

            if rates.keys.present?
              # get the items that have data
              items = rates.keys

              # get the unique dates
              dates = rates.values.flatten(1).map{|x| [x[0], x[2]]}.uniq.sort

              # create csv
              header = ['Date', items].flatten
              csv = CSV.generate do |csv_row|
                csv_row << header
    
                # for each date, add exchange rate of each item
                dates.each do |date|
                  data_item = [date[1]]

                  # get exchange rate for this date
                  items.each do |item|
                    header << item
                    index = rates[item].index{|x| x[0] == date[0]}
                    if index.present?
                      data_item << rates[item][index][1]
                    else
                      data_item << nil
                    end
                  end

                  csv_row << data_item
                end
              end

              filename << "__#{params[:type]}__#{currency[0]}__#{filename_items.join('_')}"
              filename << "__#{I18n.l Time.now, :format => :file_no_space}"
            end
          end
        end
    end

    respond_to do |format|
      format.csv {
        if csv.nil?
          return false
        else
          send_data csv, 
            :type => 'text/csv; header=present',
            :disposition => "attachment; filename=#{clean_filename(filename)}.csv"
        end
      }
    end
  end


private

  # convert string date to normal date
  def to_date(date)
     Rails.logger.debug("--------------------------------------------#{date}#{Date.parse(date)}")
    begin
      Date.parse(date)
    rescue  
      nil
    end
  end

end
