# scraper.rake
# encoding: UTF-8

require 'csv'
require 'open-uri'
require 'nokogiri'

class Rates
  def self.populate!
puts "loading nbg rates"
    ActiveRecord::Base.connection.execute("truncate table rates")

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
# load currency information
puts "loading currency information"
    currencyInfo = CSV.open("#{Rails.root}/datafiles/info/data.csv", headers: false).read
    created_at = Time.now
    ActiveRecord::Base.connection.execute("truncate table currencies")
    ActiveRecord::Base.connection.execute("truncate table currency_translations")
    sql = "insert into currencies (code, ratio, created_at, updated_at) values "
    sql1 = "insert into currency_translations (currency_id, locale, name, created_at, updated_at) values "
    currencyInfo.each_with_index do |t,i|
      sql << "(\"#{t[2]}\", #{t[3]}, \"#{created_at}\", \"#{created_at}\"),"
      sql1 << "(\"#{i+1}\", \"en\", \"#{t[0]}\", \"#{created_at}\", \"#{created_at}\"),"
      sql1 << "(\"#{i+1}\", \"ka\", \"#{t[1]}\", \"#{created_at}\", \"#{created_at}\"),"
    end
    sql[sql.length-1] = ''
    sql1[sql1.length-1] = ''
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.execute(sql1)

# load bank information
puts "loading bank information"
    bankInfo = CSV.open("#{Rails.root}/datafiles/info/banks.csv", headers: false).read
    created_at = Time.now
    ActiveRecord::Base.connection.execute("truncate table banks")
    ActiveRecord::Base.connection.execute("truncate table bank_translations")

    sql = "insert into banks (code, buy_color, sell_color, created_at, updated_at) values "
    sql1 = "insert into bank_translations (bank_id, locale, name, image, created_at, updated_at) values "
    bankInfo.each_with_index do |t,i|
      sql << "(\"#{t[0]}\", \"#{t[5]}\", \"#{t[6]}\", \"#{created_at}\", \"#{created_at}\"),"
      sql1 << "(\"#{i+1}\", \"en\", \"#{t[1]}\", \"#{t[3] + (t[4]=='1' ? '' : '_en' )}\", \"#{created_at}\", \"#{created_at}\"),"
      sql1 << "(\"#{i+1}\", \"ka\", \"#{t[2]}\", \"#{t[3] + (t[4]=='1' ? '' : '_ge' )}\", \"#{created_at}\", \"#{created_at}\"),"
    end
    sql[sql.length-1] = ''
    sql1[sql1.length-1] = ''
    ActiveRecord::Base.connection.execute(sql)
    ActiveRecord::Base.connection.execute(sql1)
puts "loading data completed"
  end

	def self.scrape!
    ActiveRecord::Base.connection.execute("truncate table rates")
    # scrape nbg
    created_at = Time.now
    date = Time.now
    # Rate.transaction do
  		# url = "http://www.nbg.ge/rss.php"
  		# page = Nokogiri::XML(open(url))

    #   # get the date
    #   title = page.at_xpath('//item//title').text
    #   date = title.gsub('Currency Rates ', '')

  		# table = page.at_xpath('//item//description').text	
  		# table = Nokogiri::HTML(table)

  		# rows = table.css('tr')
    #   puts "saving #{rows.length} records for #{date}" 
  		# rows.each do |row|
  		#   cols = row.css('td')
    #     Rate.create_or_update(date, cols[0].text.strip, cols[2].text.strip,nil,nil,1)
  		# end
    # end


    # scrape bog

      Rate.transaction do
        url = "http://bankofgeorgia.ge/ge/services/treasury-operations/exchange-rates"
        page = Nokogiri::HTML(open(url))
        rows = page.css('div#Content table tbody tr')
        rows.each do |row|
          cols = row.css('td')
          Rate.create_or_update(date, cols[1].text.strip, nil, cols[3].text.strip,cols[4].text.strip,2)
        end
        puts "Bog - saving #{rows.length} records for #{date.strftime("%d/%m/%Y")}" 
      end

    # # scrape tbc

    #   Rate.transaction do
    #     url = "http://bankofgeorgia.ge/ge/services/treasury-operations/exchange-rates"
    #     page = Nokogiri::HTML(open(url))
    #     rows = page.css('div#Content table tbody tr')
    #     rows.each do |row|
    #       cols = row.css('td')
    #       Rate.create_or_update(date, cols[1].text.strip, nil, cols[3].text.strip,cols[4].text.strip,2)
    #     end
    #     puts "TBC - saving #{rows.length} records for #{date.strftime("%d/%m/%Y")}" 
    #   end

  end

end


# <tr>
#   <td>AED</td>
#   <td>10 არაბეთის გაერთიანებული საამიროების დირჰამი</td>
#   <td>5.9305</td>
#   <td><img src="https://www.nbg.gov.ge/images/red.gif"></td>
#   <td>0.0182</td>
# </tr>


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