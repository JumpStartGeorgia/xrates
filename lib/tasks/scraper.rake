# scraper.rake
# encoding: UTF-8

require 'csv'
require 'open-uri'
require 'nokogiri'

class Rates
  def self.populate!
    files = Dir.glob("/home/eric/Desktop/xrates_data/*.csv")

		files.each do |file|
			puts "#{file}"

			data = CSV.open(file, headers: true).read

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

			currencies = data.headers
			currencies.delete_if { |label| label == "Date" }

			data.each do |row|
				currencies.each do |col|
			    date_orig = row[0].split('-')
			    time = "20#{date_orig[2]}-#{months[date_orig[1]]}-#{date_orig[0]}"

			    abbrev = col
				  rate = row[col]

		      
			    info = { :date => time, :currency => abbrev, :rate => rate }
			    Rate.create(info)
			  end
			end
		end
  end

	def self.scrape!

		time = Time.now.strftime("%Y-%m-%d")

		url = "http://www.nbg.ge/rss.php"
		page = Nokogiri::XML(open(url))
		table = page.at_xpath('//item//description').text	

		table = Nokogiri::HTML(table)

		rows = table.css('tr')

		rows.each do |row|
		  cols = row.css('td')

		  abbrev = cols[0].text
		  rate = cols[2].text

		  data = { :date => time, :currency => abbrev, :rate => rate }
		  Rate.create(data)
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