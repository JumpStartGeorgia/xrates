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

  def self.scrape!
    #ActiveRecord::Base.connection.execute("truncate table rates")
    require 'json'
    created_at = Time.now
    date = Time.now

    mailer = { bnln:0, baga:0, tbcb:0, repl:0, lbrt:0 }

puts "Scrape for #{date.to_date} at #{date}"
# scrape nbg -----------------------------------------------------------------------
    Rate.transaction do
      page = Nokogiri::XML(open("http://www.nbg.ge/rss.php"))

      # get the date
      title = page.at_xpath('//item//title').text
      date = title.gsub('Currency Rates ', '')
      date = Date.strptime(date, "%Y-%m-%d")

      table = page.at_xpath('//item//description').text 
      table = Nokogiri::HTML(table)

      rows = table.css('tr')
      puts "NBG - #{rows.length} records" 

      mailer[:bnln] = 1 if rows.empty?

      rows.each do |row|
        cols = row.css('td')
        Rate.create_or_update(date, cols[0].text.strip, cols[2].text.strip,nil,nil,1)
      end
   
    end

# scrape bog -----------------------------------------------------------------------

      Rate.transaction do
        page = Nokogiri::HTML(open("http://bankofgeorgia.ge/ge/services/treasury-operations/exchange-rates"))
        rows = page.css('div#Content table tbody tr')
        mailer[:baga] = 1 if rows.empty?
        rows.each do |row|
          cols = row.css('td')
          Rate.create_or_update(date, cols[1].text.strip, nil, cols[3].text.strip,cols[4].text.strip,2)
        end
        puts "BOG - #{rows.length} records" 
      end

# scrape tbc -----------------------------------------------------------------------
      Rate.transaction do
        page = Nokogiri::HTML(open("http://www.tbcbank.ge/web/en/web/guest/exchange-rates"))

        script = page.css('div#ExchangeRates script').text
        search_phrase = 'var tbcBankRatesJSON = eval("'
        start_index = script.index(search_phrase)
        script = script[start_index + search_phrase.length, script.length-1]
        end_index = script.index('")')
        script = script[0,end_index].gsub("\\","")
        rows = JSON.parse(script)

        cnt = 0
        swap = { "AVD" => "AUD","RUR" => "RUB","UKG" => "UAH"}
        mailer[:tbcb] = 1 if rows.empty?
        rows.each do |row|
          curr = row["currencyCode"]
          if curr != 'GEL'
            rate = row["refRates"].select{|x| x["refCurrencyCode"] == 'GEL'}.first
            if rate.present?
              if swap.key?(curr)
                curr = swap[curr]
              end
              Rate.create_or_update(date, curr, nil, rate["buyRate"], rate["sellRate"],3)
              cnt += 1
            end
          end                
        end
        puts "TBC - #{cnt} records" 
      end

  # scrape republic -----------------------------------------------------------------------
      Rate.transaction do
        page = Nokogiri::HTML(open("https://www.br.ge/en/home"))

        script = page.css('div.rates script').text
        search_phrase = 'var valRates = {'
        start_index = script.index(search_phrase)
        script = script[start_index + search_phrase.length-1, script.length-1]
        end_index = script.index('};')
        script = script[0,end_index+1].gsub(/[[:space:]]/, '')[0..-3] + "}"
        rows = JSON.parse(script)
        keys = rows.keys
        swap = {"RUR" => "RUB"}

        cnt = 0
        mailer[:repl] = 1 if rows.empty?
        keys.each do |row|
          curr = row
          if curr != 'GEL'
            if swap.key?(curr)
              curr = swap[curr]
            end
            Rate.create_or_update(date, curr, nil, rows[row]["kas"]["buy"], rows[row]["kas"]["sell"], 4)
            cnt += 1
          end
        end
        puts "REPUBLIC - #{cnt} records" 
      end
# scrape liberty -----------------------------------------------------------------------
      Rate.transaction do
        page = Nokogiri::HTML(open("https://libertybank.ge/index.php?action=valuta&lang=eng"))

        rows = page.css('body div table tr:nth-child(4) td table tr td:nth-child(3) div table tr:not(:first-child)')
        swap = {"TRL" => "TRY", "AZM" => "AZN"}
        cnt = 0
        mailer[:lbrt] = 1 if rows.empty?
        rows.each do |row|
          curr = row.css('td:nth-child(1) img').attribute('src').value
          curr = curr[curr.length-7,3].upcase
          if swap.key?(curr)
            curr = swap[curr]
          end
          Rate.create_or_update(date, curr, nil, row.css('td:nth-child(2)').text, row.css('td:nth-child(3)').text ,5)
          cnt += 1      
        end
        puts "LIBERTY - #{cnt} records"         
      end

      send = false
      failed_banks = []
      mailer.each {|k,v|
        if v == 1          
          failed_banks.push(Bank.find_by_code(k.upcase).translation_for(:en).name)
          send = true
        end
      } 
      if send 
        ScraperMailer.bank_failes(failed_banks).deliver
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