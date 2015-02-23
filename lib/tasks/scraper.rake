# scraper.rake
# encoding: UTF-8

require 'csv'
require 'open-uri'
require 'nokogiri'

class Rates
  def self.populate!
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
  			puts "#{file}"

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
          sql = "insert into rates (date, utc, currency, rate, created_at, updated_at) values "
          sql << rows.map{|x| "(\"#{x[:date]}\", \"#{x[:utc]}\", \"#{x[:currency]}\", \"#{x[:rate]}\", \"#{created_at}\", \"#{created_at}\")"}.join(', ')
          ActiveRecord::Base.connection.execute(sql)
        end

  		end
    end
  end

	def self.scrape!

    created_at = Time.now

    Rate.transaction do
  		url = "http://www.nbg.ge/rss.php"
  		page = Nokogiri::XML(open(url))

      # get the date
      title = page.at_xpath('//item//title').text
      date = title.gsub('Currency Rates ', '')

  		table = page.at_xpath('//item//description').text	
  		table = Nokogiri::HTML(table)

  		rows = table.css('tr')
      puts "saving #{rows.length} records for #{date}" 
  		rows.each do |row|
  		  cols = row.css('td')
        Rate.create_or_update(date, cols[0].text.strip, cols[2].text.strip)
  		end
    end
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