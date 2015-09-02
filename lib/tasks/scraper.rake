# scraper.rake
# encoding: UTF-8

require 'csv'
require 'open-uri'
require 'nokogiri'

class Rates
  def self.populate!
puts "loading nbg rates"
    #ActiveRecord::Base.connection.execute("truncate table rates")

    files = Dir.glob("#{Rails.root}/datafiles/*.csv")

    months = {
      'Jan' => '01',
      'Feb' => '02',
      'Mar' => '03',
      'Apr' => '04',
      'May' => '05',
      'Jun' => '06',
      'Jul' => '07',
      'Aug' => '08',
      'Sep' => '09',
      'Oct' => '10',
      'Nov' => '11',
      'Dec' => '12'
    }

    Rate.transaction do
  		files.each do |file|
  			#puts "#{file}"


  			data = CSV.open(file, headers: true).read

  			currencies = data.headers
  			currencies.delete_if { |label| label == "Date" }

        rows = []
        created_at = Time.now
  			data.each do |row|
  				currencies.each do |col|
  			    date_orig = row[0].split('-')
  			    rows << { :date => "20#{date_orig[2]}-#{months[date_orig[1]]}-#{date_orig[0]}",
                      :utc => Time.utc("20#{date_orig[2]}", "#{months[date_orig[1]]}", "#{date_orig[0]}"),
                      :currency => col, :rate => row[col] }
  			  end
  			end

        if rows.present?
          sql = "insert into rates (date, utc, bank_id, currency, buy_price, sell_price, rate, created_at, updated_at) values "
          sql << rows.map{|x| "(\"#{x[:date]}\", \"#{x[:utc]}\", 1, \"#{x[:currency]}\", \"#{x[:rate]}\", null, \"#{x[:rate]}\", \"#{created_at}\", \"#{created_at}\")"}.join(', ')
          ActiveRecord::Base.connection.execute(sql)
        end

  		end
    end
## this is done in seed file now
# # load currency information
# puts "loading currency information"
#     currencyInfo = CSV.open("#{Rails.root}/datafiles/info/data.csv", headers: false).read
#     created_at = Time.now
#     ActiveRecord::Base.connection.execute("truncate table currencies")
#     ActiveRecord::Base.connection.execute("truncate table currency_translations")
#     sql = "insert into currencies (code, ratio, created_at, updated_at) values "
#     sql1 = "insert into currency_translations (currency_id, locale, name, created_at, updated_at) values "
#     currencyInfo.each_with_index do |t,i|
#       sql << "(\"#{t[2]}\", #{t[3]}, \"#{created_at}\", \"#{created_at}\"),"
#       sql1 << "(\"#{i+1}\", \"en\", \"#{t[0]}\", \"#{created_at}\", \"#{created_at}\"),"
#       sql1 << "(\"#{i+1}\", \"ka\", \"#{t[1]}\", \"#{created_at}\", \"#{created_at}\"),"
#     end
#     sql[sql.length-1] = ''
#     sql1[sql1.length-1] = ''
#     ActiveRecord::Base.connection.execute(sql)
#     ActiveRecord::Base.connection.execute(sql1)

# # load bank information
# puts "loading bank information"
#     bankInfo = CSV.open("#{Rails.root}/datafiles/info/banks.csv", headers: false).read
#     created_at = Time.now
#     ActiveRecord::Base.connection.execute("truncate table banks")
#     ActiveRecord::Base.connection.execute("truncate table bank_translations")

#     sql = "insert into banks (code, buy_color, sell_color, created_at, updated_at) values "
#     sql1 = "insert into bank_translations (bank_id, locale, name, image, created_at, updated_at) values "
#     bankInfo.each_with_index do |t,i|
#       sql << "(\"#{t[0]}\", \"#{t[5]}\", \"#{t[6]}\", \"#{created_at}\", \"#{created_at}\"),"
#       sql1 << "(\"#{i+1}\", \"en\", \"#{t[1]}\", \"#{t[3] + (t[4]=='1' ? '' : '_en' )}\", \"#{created_at}\", \"#{created_at}\"),"
#       sql1 << "(\"#{i+1}\", \"ka\", \"#{t[2]}\", \"#{t[3] + (t[4]=='1' ? '' : '_ge' )}\", \"#{created_at}\", \"#{created_at}\"),"
#     end
#     sql[sql.length-1] = ''
#     sql1[sql1.length-1] = ''
#     ActiveRecord::Base.connection.execute(sql)
#     ActiveRecord::Base.connection.execute(sql1)
puts "loading data completed"
  end
  def self.is_number? string
    true if Float(string) rescue false
  end
  def self.swap(s)
    s = s.gsub(/[[:space:]]/, '').chomp.upcase
    swap = {"RUR" => "RUB"}
    return swap.key?(s) ? swap[s] : s
  end
  def self.n(s)
    return s.gsub(/[[:space:]]/, '')
  end
  def self.check_rates(buy, sell)
    return is_number?(buy) && is_number?(sell) && buy.to_f != 0 && sell.to_f != 0
  end
  def self.scrape!
    #ActiveRecord::Base.connection.execute("truncate table rates")
    require 'json'
    created_at = Time.now
    date = Time.now

    fail_flags = { bnln:0, baga:0, tbcb:0, repl:0, lbrt:0, proc:0, cart:0, vtb:0, prog:0, ksb:0, basis:0, captial:0, finca:0, halyk:0, silk:0, pasha:0, azer:0 }
    processed_flags = { bnln:0, baga:0, tbcb:0, repl:0, lbrt:0, proc:0, cart:0, vtb:0, prog:0, ksb:0, basis:0, capital:0, finca:0, halyk:0, silk:0, pasha:0, azer:0 }

    puts "Scrape for #{date.to_date} at #{date}"

    # scrape nbg -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::XML(open("http://www.nbg.ge/rss.php"))

    #     # get the date
    #     title = page.at_xpath('//item//title').text
    #     date = title.gsub('Currency Rates ', '')
    #     date = Date.strptime(date, "%Y-%m-%d")

    #     table = page.at_xpath('//item//description').text
    #     table = Nokogiri::HTML(table)

    #     rows = table.css('tr')
    #     puts "NBG - #{rows.length} records"
    #     processed_flags[:bnln] = rows.length
    #     fail_flags[:bnln] = 1 if rows.empty?

    #     rows.each do |row|
    #       cols = row.css('td')
    #       Rate.create_or_update(date, cols[0].text.strip, cols[2].text.strip,nil,nil,1)
    #     end

    #   end

    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end


    # scrape bog -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://bankofgeorgia.ge/ge/services/treasury-operations/exchange-rates"))
    #     rows = page.css('div#Content table tbody tr')
    #     fail_flags[:baga] = 1 if rows.empty?
    #     rows.each do |row|
    #       cols = row.css('td')
    #       Rate.create_or_update(date, cols[1].text.strip, nil, cols[3].text.strip,cols[4].text.strip,2)
    #     end
    #     puts "BOG - #{rows.length} records"
    #     processed_flags[:baga] = rows.length
    #   end

    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end

    # scrape tbc -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.tbcbank.ge/web/en/web/guest/exchange-rates"))

    #     script = page.css('div#ExchangeRates script').text
    #     search_phrase = 'var tbcBankRatesJSON = eval("'
    #     start_index = script.index(search_phrase)
    #     script = script[start_index + search_phrase.length, script.length-1]
    #     end_index = script.index('")')
    #     script = script[0,end_index].gsub("\\","")
    #     rows = JSON.parse(script)

    #     cnt = 0
    #     swap = { "AVD" => "AUD","RUR" => "RUB","UKG" => "UAH"}
    #     fail_flags[:tbcb] = 1 if rows.empty?
    #     rows.each do |row|
    #       curr = row["currencyCode"]
    #       if curr != 'GEL'
    #         rate = row["refRates"].select{|x| x["refCurrencyCode"] == 'GEL'}.first
    #         if rate.present?
    #           if swap.key?(curr)
    #             curr = swap[curr]
    #           end
    #           Rate.create_or_update(date, curr, nil, rate["buyRate"], rate["sellRate"],3)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     puts "TBC - #{cnt} records"
    #     processed_flags[:tbcb] = cnt
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end

    # scrape republic -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("https://www.br.ge/en/home",  :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

    #     script = page.css('div.rates script').text
    #     search_phrase = 'var valRates = {'
    #     start_index = script.index(search_phrase)
    #     script = script[start_index + search_phrase.length-1, script.length-1]
    #     end_index = script.index('};')
    #     script = script[0,end_index+1].gsub(/[[:space:]]/, '')[0..-3] + "}"
    #     rows = JSON.parse(script)
    #     keys = rows.keys
    #     swap = {"RUR" => "RUB"}

    #     cnt = 0
    #     fail_flags[:repl] = 1 if rows.empty?
    #     keys.each do |row|
    #       curr = row
    #       if curr != 'GEL'
    #         if swap.key?(curr)
    #           curr = swap[curr]
    #         end
    #         Rate.create_or_update(date, curr, nil, rows[row]["kas"]["buy"], rows[row]["kas"]["sell"], 4)
    #         cnt += 1
    #       end
    #     end
    #     puts "REPUBLIC - #{cnt} records"
    #     processed_flags[:repl] = cnt
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end

    # scrape liberty -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("https://libertybank.ge/en/pizikuri-pirebistvis",  :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE))

    #     rows = page.css('body div.box.rates table tbody tr')
    #     swap = {"TRL" => "TRY", "AZM" => "AZN"}
    #     cnt = 0
    #     fail_flags[:lbrt] = 1 if rows.empty?
    #     rows.each do |row|
    #       curr = row.css('th').text.upcase
    #       Rate.create_or_update(date, curr, nil, row.css('td')[0].text, row.css('td')[1].text ,5)
    #       cnt += 1
    #     end
    #     puts "LIBERTY - #{cnt} records"
    #     processed_flags[:lbrt] = cnt
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end

#_National Bank of Georgia - https://www.nbg.gov.ge/index.php?m=582
#_Bank of Georgia - http://bankofgeorgia.ge/ge/services/treasury-operations/exchange-rates
#_TBC - http://www.tbcbank.ge/web/ka/web/guest/exchange-rates 
#_Bank Republic - https://www.br.ge/ge/home
#_Liberty Bank - https://libertybank.ge/?action=valuta&lang=geo
#_ProCredit Bank - http://www.procreditbank.ge/
#_Cartu Bank - http://www.cartubank.ge/?lng=eng
#_VTB Bank - http://en.vtb.ge/rates/
#_Progress Bank - http://progressbank.ge/eng/
#_KSB Bank - http://www.ksb.ge/en/
#_Basis Bank - http://www.basisbank.ge/ge/currency/ 
#_Capital Bank - http://capitalbank.ge/en/Xml
#_Finca Bank -http://www.finca.ge/index.php?pg_symbol=999990005#contentOne-tab 
#_Halyk Bank - http://hbg.ge/en/
#_Silkroadbank http://www.silkroadbank.ge/geo/home
#_PASHA Bank Georgia PAHAGE22 http://www.pashabank.ge/en/exchange-rates has history
#_International Bank of Azerbaijan - IBAZ - http://www.ibaz.ge/index.php


#"Caucasus Development Bank – Georgia" CS DEVGGE22 

#Rico Credit - http://rico.ge/
#Crystal - http://crystal.ge/en/
#Creditplus - http://www.creditplus.ge/?lng=eng
#Leader Credit - http://leadercredit.ge/
#Fincredit - http://fincredit.ge/

#---------------ISBANK Georgia - ISBK - http://www.isbank.ge/eng/default.aspx - no currency info
#---------------Ziraat Bank" Tbilisi - TCZB - http://ziraatbank.ge/retail-banking-services/currency-exchange - no currency info
#---------------BTA Bank - http://www.bta.ge/geo/home #closed
#---------------Privat Bank - http://privatbank.ge/ge/ #georgian bank
#
# scrape procredit -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.procreditbank.ge/"))
    #     items = page.css('tr#right_table1 td.valuta').first.parent.parent.css("> tr") #[0].css("td table tr").text
    #     cnt = 0
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 3)
    #         d = [swap(c[0].text.strip.upcase), c[1].text.strip, c[2].text.strip]
    #          if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 6)
    #           cnt += 1
    #          end
    #       end
    #     end
    #     fail_flags[:proc] = 1 if cnt == 0
        
    #     processed_flags[:proc] = cnt
    #     puts "PROCREDIT - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end    
# scrape cartu refactor-----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.cartubank.ge/?lng=eng"))
    #     items = page.css('div.block_title:contains("Currency Rates (GEL)")').first.parent.css("> table > tr")
    #     cnt = 0
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 4)
    #         d = [swap(c[0].text.strip.upcase), c[1].text.strip, c[2].text.strip]
    #          if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 7)
    #           cnt += 1
    #          end
    #       end
    #     end
    #     fail_flags[:cart] = 1 if cnt == 0
        
    #     processed_flags[:cart] = cnt
    #     puts "CARTU - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end   
# scrape vtb -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://en.vtb.ge/rates/"))
    #     items = page.css('#tab_con_dochki_table table tbody tr')
    #     cnt = 0
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 4 && c[1].css("span").text.upcase == "GEL")
    #         d = [swap(c[0].css("span").text.strip.upcase), c[2].text.strip, c[3].text.strip]
    #          if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 8)
    #           cnt += 1
    #          end
    #       end
    #     end
    #     fail_flags[:vtb] = 1 if cnt == 0
        
    #     processed_flags[:vtb] = cnt
    #     puts "VTB - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end   
# scrape progress -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://progressbank.ge/eng/"))
    #     items = page.css('#ratesblock #nbg table tr')
    #     cnt = 0        
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 5)
    #         d = [swap(c[1].text.strip.upcase), c[3].text.strip, c[4].text.strip]
    #          if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 9)
    #           cnt += 1
    #          end
    #       end
    #     end
    #     fail_flags[:prog] = 1 if cnt == 0
        
    #     processed_flags[:prog] = cnt
    #     puts "Progress - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape ksb -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.ksb.ge/en/"))

    #     script = page.css('.content script').text
    #     search_phrase = "window.KsbCurrencies = ["
    #     start_index = script.index(search_phrase)
    #     script = script[start_index + search_phrase.length-1, script.length-1]
    #     end_index = script.index('}];')
    #     script = script[0,end_index+1].strip + "]"
    #     items = JSON.parse(script)

    #     cnt = 0        
    #     items.each do |item|
    #       c = item          
    #       d = [swap(c["FromCurrency"].strip.upcase), c["Buy"], c["Sell"]]
    #       if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #         Rate.create_or_update(date, d[0], nil, d[1], d[2], 10)
    #         cnt += 1
    #       end
    #     end
    #     fail_flags[:ksb] = 1 if cnt == 0
        
    #     processed_flags[:ksb] = cnt
    #     puts "KSB - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end
# scrape basis -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.basisbank.ge/en/currency/"))
    #     items = page.css('#curr_table tr table tr')
    #     cnt = 0        
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 4)
    #         d = [swap(c[0].text.strip.upcase), c[1].text.strip, c[2].text.strip]
    #          if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 11)
    #           cnt += 1
    #          end
    #       end
    #     end
    #     fail_flags[:basis] = 1 if cnt == 0
        
    #     processed_flags[:basis] = cnt
    #     puts "Basis - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape capital -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://capitalbank.ge/en/Xml"))
    #     items = page.css('.curr_wrapper ul.fi')
    #     cnt = 0        
    #     items.each do |item|
    #       c = item.css("li")
    #       if(c.length == 3)
    #         d = [swap(c[0].text.strip.upcase), c[1].text.strip, c[2].text.strip]
    #         if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2]) && d[0] == swap(item["id"].strip.upcase)
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 12)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     fail_flags[:capital] = 1 if cnt == 0
        
    #     processed_flags[:capital] = cnt
    #     puts "Capital - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape finca -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.finca.ge/en/"))
    #     items = page.css('#CT1.bcontent table tr')
    #     cnt = 0        
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 3)
    #         d = [swap(c[0].text.strip.upcase), c[1].text.strip, c[2].text.strip]
    #         if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 13)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     fail_flags[:finca] = 1 if cnt == 0
        
    #     processed_flags[:finca] = cnt
    #     puts "Finca - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape halyk -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://hbg.ge/en/"))
    #     items = page.css('.right_holder .box table tr')
    #     cnt = 0        
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 4)
    #         d = [swap(c[0].text.strip.upcase), c[1].text.strip, c[2].text.strip]
    #         if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 14)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     fail_flags[:halyk] = 1 if cnt == 0
        
    #     processed_flags[:halyk] = cnt
    #     puts "Halyk - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape silk -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.silkroadbank.ge/eng/home"))
    #     items = page.css('table.currencyContainer tr')
    #     cnt = 0       
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 3)
    #         d = [swap(c[0].text), n(c[1].text), n(c[2].text)]
    #         if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 15)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     fail_flags[:silk] = 1 if cnt == 0
        
    #     processed_flags[:silk] = cnt
    #     puts "Silkroad - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape pasha -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.pashabank.ge/en/exchange-rates"))
    #     items = page.css('.exchange1 table tbody tr')
    #     cnt = 0       
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 3)
    #         d = [swap(c[0].text), n(c[1].text), n(c[2].text)]
    #         if d[0].length == 3 && is_number?(d[1]) && is_number?(d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 16)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     fail_flags[:pasha] = 1 if cnt == 0
    #     processed_flags[:pasha] = cnt
    #     puts "Pasha - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# scrape azerbaijan  -----------------------------------------------------------------------
    # begin
    #   Rate.transaction do
    #     page = Nokogiri::HTML(open("http://www.ibaz.ge/index.php?lang_id=2"))
    #     items = []
    #     page.css('td').each {|item|          
    #       if item.inner_text == "USD"            
    #         items = item.parent.parent.css("> tr")
    #         break
    #       end
    #     }
    #     cnt = 0      
    #     items.each do |item|
    #       c = item.css("td")
    #       if(c.length == 11)
    #         d = [swap(c[3].text), n(c[5].text), n(c[7].text)]            
    #         if d[0].length == 3 && check_rates(d[1],d[2])
    #           Rate.create_or_update(date, d[0], nil, d[1], d[2], 17)
    #           cnt += 1
    #         end
    #       end
    #     end
    #     fail_flags[:azer] = 1 if cnt == 0
    #     processed_flags[:azer] = cnt
    #     puts "Azerbaijan - #{cnt} records"
    #   end
    # rescue  Exception => e
    #   ScraperMailer.report_error(e).deliver
    # end 
# errors  -----------------------------------------------------------------------
    begin
      send_failed_msg = false
      failed_banks = []
      fail_flags.each {|k,v|
        if v == 1
          failed_banks.push(Bank.find_by_code(k.upcase).translation_for(:en).name)
          send_failed_msg = true
        end
      }
      processed_banks = []
      processed_flags.each {|k,v|
        processed_banks.push(Bank.find_by_code(k.upcase).translation_for(:en).name + " - " + v.to_s + " records recorded")
      }
      if send_failed_msg
        ScraperMailer.banks_failed(failed_banks).deliver
      end
      #ScraperMailer.banks_processed(processed_banks).deliver
    rescue  Exception => e
      ScraperMailer.report_error(e).deliver
    end
    # LAST_SCRAPE = Time.now
  end
end


namespace :rates do
  desc "Populate database"
  task :populate => :environment do
    Rates.populate!
  end

  desc "Run scraper"
  task :scrape => :environment do
    Rates.scrape!
  end
end
