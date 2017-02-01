# scraper.rake
# encoding: UTF-8

require 'csv'
#require 'open-uri'
require 'nokogiri'
require 'mechanize'

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
    #--
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
    swap = {"RUR" => "RUB", "TRL" => "TRY", "AZM" => "AZN", "AVD" => "AUD", "UKG" => "UAH", "BYN" => "BYR"}
    return swap.key?(s) ? swap[s] : s
  end
  def self.n(s)
    s.gsub!(/[[:space:]]/, '') # remove all kind of spaces
    s += "0" if s != "" && s[s.length-1] == "." # for cases when number is written without any number after dot but dot itself is there add 0 after dot(9. => 9.0)
    return s
  end
  def self.check_rates(currency, buy, sell)
    return currency.length == 3 && !@currencies.index(currency).nil? && is_number?(buy) && is_number?(sell) && buy.to_f != 0 && sell.to_f != 0
  end
  # for turned off banks based on path and parent_tag checks if bank site structure was changed
  # we should provide parent tag that will be on sure changed after they upgrade site
  def self.is_back(bank)
    begin
      page = nil
      agent = Mechanize.new
      if bank[:ssl].present? && bank[:ssl]
        agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
      end
      page = Nokogiri::HTML(agent.get(bank[:path]).content)

      elem = (bank[:parent_tag].is_a? Proc) ? bank[:parent_tag].call(page) : page.at_css(bank[:parent_tag])
      if elem.nil?
        @returned_banks.push bank[:id]
        puts "#{bank[:name]} - is probably back"
      else
        puts "#{bank[:name]} - is off"
      end

    #     end
    rescue  Exception => e
      puts "#{bank[:name]} - exception occured for bank that is off #{e}"
    end
  end

  @currencies = []
  @returned_banks = []
  def self.scrape!
    #ActiveRecord::Base.connection.execute("truncate table rates")
    require 'json'
    @currencies = Currency.pluck(:code)
    created_at = Time.now
    date = Time.now
    puts "Scrape for #{date.to_date} at #{date}"


    #fail_flags = { bnln:0, baga:0, tbcb:0, repl:0, lbrt:0, proc:0, cart:0, vtb:0, prog:0, tera:0, basis:0, captial:0, finca:0, halyk:0, silk:0, pasha:0, azer:0, caucasus:0 }
    #processed_flags = { bnln:0, baga:0, tbcb:0, repl:0, lbrt:0, proc:0, cart:0, vtb:0, prog:0, tera:0, basis:0, capital:0, finca:0, halyk:0, silk:0, pasha:0, azer:0, caucasus:0 }

    # array of banks options for scraping
    banks = [
      { name: "National Bank of Georgia",
        id:1,
        path:"http://www.nbg.ge/rss.php",
        parent_tag:"//item//title",
        child_tag:"td",
        child_tag_count:5,
        position:[0, 2, 0],
        threshold: 43,
        cnt:0 },
      { name: "Bank of Georgia",
        id:2,
        path:"http://bankofgeorgia.ge/ge/services/treasury-operations/exchange-rates",
        parent_tag:"div#Content table tbody tr",
        child_tag:"td",
        child_tag_count:5,
        position:[1, 3, 4],
        threshold: 34,
        cnt:0 },
      { name: "TBC Bank",
        id:3,
        path:"http://www.tbcbank.ge/web/en/web/guest/exchange-rates",
        parent_tag:"div#ExchangeRates script",
        child_tag:"",
        child_tag_count:0,
        position:[0, 0, 0],
        threshold: 17,
        cnt:0,
        script: true,
        script_callback: lambda {|script, bank|
          script = script.text
          search_phrase = 'var tbcBankRatesJSON = eval("'
          start_index = script.index(search_phrase)
          script = script[start_index + search_phrase.length, script.length-1]
          end_index = script.index('")')
          script = script[0,end_index].gsub("\\","")
          rows = JSON.parse(script)

          items = []
          rows.each { |row|
            curr = swap(row["currencyCode"])
            if curr != 'GEL'
              c = row["refRates"].select{|x| x["refCurrencyCode"] == 'GEL'}.first
              items.push([ curr, n(c["buyRate"].to_s), n(c["sellRate"].to_s)]) if c.present?
            end
          }
          return items
        } },
      { name: "Bank Republic",
        id:4,
        path:"https://www.br.ge/en/home",
        parent_tag:"div.rates script",
        child_tag:"",
        child_tag_count:0,
        position:[0, 0, 0],
        threshold: 4,
        cnt:0,
        ssl: true,
        script: true,
        script_callback: lambda {|script, bank|
          script = script.text
          search_phrase = 'var valRates = {'
          start_index = script.index(search_phrase)
          script = script[start_index + search_phrase.length-1, script.length-1]
          end_index = script.index('};')
          script = script[0,end_index+1].gsub(/[[:space:]]/, '')[0..-3] + "}"
          rows = JSON.parse(script)

          items = []
          rows.keys.each do |row|
            curr = swap(row)
            if curr != 'GEL'
              items.push([ curr, n(rows[row]["kas"]["buy"].to_s), n(rows[row]["kas"]["sell"].to_s)])
            end
          end
          return items
        } },
      { name: "Liberty Bank",
        id:5,
        path:"https://libertybank.ge/en/pizikuri-pirebistvis",
        parent_tag:"body div.box.rates table tbody tr",
        child_tag:"th, td",
        child_tag_count:4,
        position:[0, 1, 2],
        threshold: 4,
        cnt:0,
        ssl: true },
      { name: "ProCredit Bank",
        id:6,
        path:"http://www.procreditbank.ge/",
        parent_tag: lambda { |page|
          return page.css('tr#right_table1 td.valuta').first.parent.parent.css("> tr")
        },
        child_tag:"td",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 3,
        cnt:0 },

      { name: "Cartu Bank",
        id:7,
        path:"http://www.cartubank.ge/?lng=eng",
        parent_tag: "#valueListBody tbody tr",
        child_tag:"th, td",
        child_tag_count:4,
        position:[0, 1, 2],
        threshold: 5,
        cnt:0 },
      # 28.04.2016
      # { name: "Cartu Bank",
      #   id:7,
      #   path:"http://www.cartubank.ge/?lng=eng",
      #   parent_tag: lambda {|page|
      #     page.css("div.block_title").each do |item|
      #       if item.inner_text.strip == "Currency Rates (GEL)"
      #         return item.parent.css("> table > tr")
      #       end
      #     end
      #   },
      #   child_tag:"td",
      #   child_tag_count:4,
      #   position:[0, 1, 2],
      #   threshold: 5,
      #   cnt:0 },
      { name: "VTB Bank",
        id:8,
        path:"http://en.vtb.ge/rates/",
        parent_tag:"#tab_con_dochki_table table tbody tr",
        child_tag:"td",
        child_tag_count:4,
        position:[0, 2, 3],
        threshold: 8,
        cnt:0,
        script: true,
        script_callback: lambda {|script, bank|
          items = []
          script.each do |item|
            c = item.css(bank[:child_tag])
            if(c.length == bank[:child_tag_count] && swap(c[1].css("span").text) == "GEL")
              items.push([swap(c[bank[:position][0]].css("span").text), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
            end
          end
          return items
        } },
      # was turn off on 24.10.2016
      { name: "Progress Bank",
        off: true,
        id:9,
        path:"http://progressbank.ge/ge/85/",
        parent_tag:".rates table tbody" },
      # was turn off from 17.05.2016 to 24.05.2016 but corrected with same layout
      # turn on 24.05.2016
      # { name: "Progress Bank",
      #   id:9,
      #   path:"http://progressbank.ge/ge/85/",
      #   parent_tag:".rates table tbody",
      #   child_tag:"td",
      #   child_tag_count:2,
      #   position:[0, 0, 1],
      #   threshold: 4,
      #   cnt:0,
      #   script:true,
      #   script_callback: lambda {|script, bank|
      #     items = []
      #     mp = { "icon-flag_us" => "USD", "icon-flag_eu" => "EUR", "icon-flag_uk" => "GBP", "icon-flag_ru" => "RUB" }
      #     script.css("tr").each do |item|
      #       cur = mp[item.css("th > div").attr("class").value]
      #       c = item.css(bank[:child_tag])
      #       if cur.present? && c.length == bank[:child_tag_count]
      #         items.push([swap(cur), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
      #       end
      #     end
      #     return items
      #   } },
      { name: "Terabank", # previous name is ksb -> tera (http://www.ksb.ge/en/ but structure stays the same)
        id:10,
        path:"http://terabank.ge/ge/retail",
        parent_tag:".content script",
        child_tag:"",
        child_tag_count:0,
        position:[0, 0, 0],
        threshold: 4,
        cnt:0,
        script: true,
        script_callback: lambda {|script, bank|
          script = script.text
          search_phrase = "window.KsbCurrencies = ["
          start_index = script.index(search_phrase)
          script = script[start_index + search_phrase.length-1, script.length-1]
          end_index = script.index('}];')
          script = script[0,end_index+1].strip + "]"
          rows = JSON.parse(script)
          items = []
          rows.each do |row|
            items.push([swap(row["FromCurrency"]), n(row["Buy"].to_s), n(row["Sell"].to_s)])
          end
          return items
        } },
      { name: "Basisbank",
        id:11,
        path:"http://www.basisbank.ge/en/currency/",
        parent_tag:"#curr_table tr table tr",
        child_tag:"td",
        child_tag_count:4,
        position:[0, 1, 2],
        threshold: 5,
        cnt:0 },
        # was turn off on 28.11.2016 due domain is off
      { name: "Capital Bank",
        off: true,
        id:12,
        path:"http://capitalbank.ge/en/Xml",
        parent_tag:"body" },
      # { name: "Capital Bank",
      #   id:12,
      #   path:"http://capitalbank.ge/en/Xml",
      #   parent_tag:".curr_wrapper ul.fi",
      #   child_tag:"li",
      #   child_tag_count:3,
      #   position:[0, 2, 1],
      #   threshold: 16,
      #   cnt:0,
      #   script: true,
      #   script_callback: lambda {|script, bank|
      #     items = []
      #     script.each do |item|
      #       c = item.css(bank[:child_tag])
      #       curr = swap(c[bank[:position][0]].text)
      #       if(c.length == bank[:child_tag_count] && curr == swap(item["id"]))
      #         items.push([curr, n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
      #       end
      #     end
      #     return items
      #   } },
      { name: "Finca Bank",
        id:13,
        path:"http://www.finca.ge/en/",
        parent_tag:"#CT1.bcontent table tr",
        child_tag:"td",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 2,
        cnt:0 },
      { name: "Halyk Bank",
        id:14,
        path:"http://www.halykbank.ge/en",
        parent_tag:"div.currency p",
        child_tag:"span",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 4, # June 13 switched to 4 from 0, previous June 12 switched from 4 to 0 due, site currency box is broken. Email sended to bank
        cnt:0 },
      # { name: "Halyk Bank",
      #   off:true,
      #   id:14,
      #   path:"http://hbg.ge",
      #   parent_tag:"#timer" },
      { name: "Silk Road Bank",
        id:15,
        # partial_off: true, # Structure of site was not changed but actual data
        # is not filled for currency, so threshold is set to 0, flag is used to
        # sort it down, beacuse it takes more time than usual, was back on same date
        path:"http://www.silkroadbank.ge/eng/home",
        parent_tag:"table.currencyContainer tr",
        child_tag:"td",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 4,
        cnt:0 },
      # on date 30.05.2016
      { name: "Pasha Bank",
        id:16,
        path:"http://www.pashabank.ge/en/exchange-rates",
        parent_tag:".exchange1 table tbody tr",
        child_tag:"td",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 4,
        cnt:0 },
      # was turn off from 17.05.2016 to 30.05.2016 but corrected with same layout
      # { name: "Pasha Bank",
      #   off: true,
      #   id:16,
      #   path:"http://www.pashabank.ge",
      #   parent_tag:"#promoslider .slide1 .lined-h2" },
      { name: "International Bank of Azerbaijan", # script was updated on 09.01.2017 because site was updated
        id:17,
        path:"http://www.ibaz.ge",
        parent_tag:".currency-wrap .info tbody tr",
        child_tag:"td",
        child_tag_count:4,
        position:[0, 1, 2],
        threshold: 4,
        cnt:0,
        script: true,
        script_callback: lambda {|script, bank|
          items = []
          script.each do |item|
            c = item.css(bank[:child_tag])
            items.push([
              swap(c[bank[:position][0]].css('i').attr('class').to_s.gsub('icon-','')),
              n(c[bank[:position][1]].text),
              n(c[bank[:position][2]].text)]
            )
          end
          return items
        } },
        # script for previous version of page structure
        # script_callback: lambda {|script, bank|
        #   tmpItems = []
        #   script.css(bank[:parent_tag]).each do |item|
        #     if item.inner_text == "USD"
        #       tmpItems = item.parent.parent.css("> tr")
        #       break
        #     end
        #   end
        #   items = []
        #   tmpItems.each do |item|
        #     c = item.css(bank[:child_tag])
        #     if c.length == bank[:child_tag_count]
        #       items.push([swap(c[bank[:position][0]].text), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
        #     end
        #   end

        #   return items } },
      # was turn off on 15.11.2016 because of domain is off, planning to remove
      # duplicates because exchange rate stopped changing
      {
        name: "Caucasus Development Bank Georgia",
        id:18,
        off: true,
        path:"http://www.cdb.ge/",
        parent_tag:"body"
      },
      # { name: "Caucasus Development Bank Georgia",
      #   id:18,
      #   path:"http://www.cdb.ge/en/",
      #   parent_tag:".exch > tbody",
      #   child_tag:"> td",
      #   child_tag_count:3,
      #   position:[0, 1, 2],
      #   threshold: 3,
      #   cnt:0,
      #   script:true,
      #   script_callback: lambda {|page, bank|

      #     html = page.inner_html
      #     index = html.index("<tr>") + 4
      #     index = html.index("<tr>", index)
      #     rows = Nokogiri::HTML(html.insert(index, "</td></tr>")).css("tr")

      #     items = []
      #     rows.each do |item|
      #       c = item.css(bank[:child_tag])
      #       if c.length == bank[:child_tag_count]
      #         items.push([swap(c[bank[:position][0]].css("img").attr("alt").value), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
      #       end
      #     end
      #     return items } },
      { name: "Rico Credit",
        id:19,
        type: :other,
        path:"http://rico.ge/",
        parent_tag:".rates",
        child_tag:"> div",
        child_tag_count:0,
        position:[0, 0, 0],
        threshold: 9,
        exclude: ["AZN"], # when currency is temporarily unavailable key: zero, "0" , "AMD"
        cnt:0,
        script: true,
        script_callback: lambda {|script, bank|
          items = []
          c = script.css(bank[:child_tag])
          c.each_with_index do |item, index|
            if index > 2
              if item.attr("class").index("curses").present?
                items.push([swap(item.text), n(c[index+1].text), n(c[index+2].text)])
              end
            end
          end
          return items } },
      { name: "Crystal Microfinance Organization",
        id:20,
        type: :other,
        path:"http://crystal.ge/en/",
        parent_tag:".currency-content.crystal tbody tr",
        child_tag:"th, td",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 4,
        cnt:0 },
      { name: "Bonaco Microfinance Organization",
        id:21,
        type: :other,
        path:"http://bonaco.ge/",
        parent_tag:"#currency_tablo ul",
        child_tag:".cur_title span, .cur_number span",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 7,
        cnt:0,
        script:true,
        script_callback: lambda {|script, bank|
          items = []
          script.css("li").each do |item|
            c = item.css(bank[:child_tag])
            if c.length == bank[:child_tag_count]
              items.push([swap(c[bank[:position][0]].text), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
            end
          end
          return items
        } },
      # on date 17.05.2016
      { name: "Alpha Express",
        id:22,
        type: :other,
        path:"https://alpha-express.ge/en",
        parent_tag:"#currency .values table tr",
        child_tag:"td",
        child_tag_count:3,
        position:[0, 1, 2],
        threshold: 4,
        cnt:0,
        script:true,
        script_callback: lambda {|script, bank|
          items = []
          script.each do |item|
            c = item.css(bank[:child_tag])
            if c.length == bank[:child_tag_count] && c[1].css("i").length > 0 && c[1].css("i").attr("class").value.index("fa-dollar").nil?
              items.push([swap(c[bank[:position][0]].text), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)])
            end
          end
          return items
        },
        ssl: true },
        # was turn off but corrected with same layout
        # { name: "Alpha Express",
        #   off: true,
        #   id:22,
        #   type: :other,
        #   path:"https://alpha-express.ge/ge",
        #   parent_tag:".cards a[href='#currency']",
        #   ssl: true },
        # not available banks
        #---------------ISBANK Georgia - ISBK - http://www.isbank.ge/eng/default.aspx - no currency info
        #---------------Ziraat Bank" Tbilisi - TCZB - http://ziraatbank.ge/retail-banking-services/currency-exchange - no currency info
        #---------------BTA Bank - http://www.bta.ge/geo/home # closed
        #---------------Privat Bank - http://privatbank.ge/ge/ # georgian bank
        #---------------Creditplus - http://www.creditplus.ge/?lng=eng - no currency info
        #---------------Leader Credit - http://leadercredit.ge/ - site is in a updating stage
        #---------------Fincredit - http://fincredit.ge/ has 2 currency but getting which is which is impossible without hard coding
        #---------------Tbilmicrocredit http://www.tbmc.ge/en/# has currency harder to get is it worth it
    ]


    # nbg -----------------------------------------------------------------------
      begin
        bank = banks[0]
        Rate.transaction do
          agent = Mechanize.new
          page = Nokogiri::XML(agent.get(bank[:path]).content) # open(bank[:path]))

          # get the date
          title = page.at_xpath(bank[:parent_tag]).text
          date = title.gsub('Currency Rates ', '')
          date = Date.strptime(date, "%Y-%m-%d")

          items = Nokogiri::HTML(page.at_xpath('//item//description').text).css('tr')

          if bank[:exclude].present? && bank[:exclude].is_a?(Array) # when exclude has currency that should be excluded temporarily then threshold shoul be changed
            bank[:orig_threshold] = bank[:threshold]
            bank[:threshold] -= bank[:exclude].length
          else
            bank[:exclude] = []
          end

          cnt = 0
          items.each do |item|
            c = item.css(bank[:child_tag])
            if(c.length == bank[:child_tag_count])
              d = [swap(c[bank[:position][0]].text), n(c[bank[:position][1]].text), 1]
              if bank[:exclude].include? d[0]
                if check_rates(d[0], d[1], d[2]) # check maybe currency data was fixed so we can turn it on, changing count means threshold will be exceeded
                  cnt += 1
                end
              else
                if check_rates(d[0], d[1], d[2])
                  Rate.create_or_update(date, d[0], d[1], nil, nil, bank[:id])
                  cnt += 1
                end
              end
            end
          end
          bank[:cnt] = cnt
          puts "#{bank[:name]} - #{cnt} records"
        end
      rescue  Exception => e
        bank[:cnt] = -1
        bank[:e] = e
        puts "#{bank[:name]} - exception occured"
      end

    # Banks that are off or partially off will be processed at the end
    banks.sort!{|x,y|
      (x.key?(:off) && x[:off]) || (x.key?(:partial_off) && x[:partial_off]) ? 1 : -1
    }

    # loop each bank, and scrape data based on array of banks options
    banks.each do |bank|
      next if bank[:id] == 1
      (is_back(bank); next;) if (bank[:off].present? && bank[:off])
      # next if (bank[:id] != 17) # || bank[:id] != 22
      begin
        page = nil
        agent = Mechanize.new
        if bank[:ssl].present? && bank[:ssl]
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        #page = Nokogiri::HTML(open(bank[:path], :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)) #else #page = Nokogiri::HTML(open(bank[:path]))
        page = Nokogiri::HTML(agent.get(bank[:path]).content)

        if bank[:exclude].present? && bank[:exclude].is_a?(Array) # when exclude has currency that should be excluded temporarily then threshold shoul be changed
          bank[:orig_threshold] = bank[:threshold]
          bank[:threshold] -= bank[:exclude].length
        else
          bank[:exclude] = []
        end

        Rate.transaction do
          items = []
          cnt = 0
          if bank[:script].present? && bank[:script]
            if bank[:script_callback].present? && (defined?(bank[:script_callback]) == "method")
              items = bank[:script_callback].call(page.css(bank[:parent_tag]), bank)
              items.each do |d|
                if bank[:exclude].include? d[0] # whole block can be optimised, cause duplication here and below
                  if check_rates(d[0], d[1], d[2]) # check maybe currency data was fixed so we can turn it on, changing count means threshold will be exceeded
                    cnt += 1
                  end
                else
                  if check_rates(d[0], d[1], d[2])
                    Rate.create_or_update(date, d[0], nil, d[1], d[2], bank[:id])
                    cnt += 1
                  end
                end
              end
            end
          else
            items = (bank[:parent_tag].is_a? Proc) ? bank[:parent_tag].call(page) : page.css(bank[:parent_tag])
            cnt = 0
            items.each do |item|
              c = item.css(bank[:child_tag])
              #pp c.length
              if(c.length == bank[:child_tag_count])
                d = [swap(c[bank[:position][0]].text), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)]
                if bank[:exclude].include? d[0]
                  if check_rates(d[0], d[1], d[2]) # check maybe currency data was fixed so we can turn it on, changing count means threshold will be exceeded
                    cnt += 1
                  end
                else
                  if check_rates(d[0], d[1], d[2])
                    Rate.create_or_update(date, d[0], nil, d[1], d[2], bank[:id])
                    cnt += 1
                  end
                end
              end
            end
          end
          bank[:cnt] = cnt
          puts "#{bank[:name]} - #{cnt} records"
        end
      rescue  Exception => e
        bank[:cnt] = -1
        bank[:e] = e
        puts "#{bank[:name]} - exception occured"
      end
    end
    # loop each bank which had an exception
    banks.each do |bank|
      next if (bank[:id] == 1 || !bank[:e].present?)
      (next;) if (bank[:off].present? && bank[:off])
      bank.delete :e
      begin
        page = nil
        agent = Mechanize.new
        if bank[:ssl].present? && bank[:ssl]
          agent.verify_mode = OpenSSL::SSL::VERIFY_NONE
        end
        #page = Nokogiri::HTML(open(bank[:path], :ssl_verify_mode => OpenSSL::SSL::VERIFY_NONE)) #else #page = Nokogiri::HTML(open(bank[:path]))
        page = Nokogiri::HTML(agent.get(bank[:path]).content)

        if bank[:exclude].present? && bank[:exclude].is_a?(Array) # when exclude has currency that should be excluded temporarily then threshold shoul be changed
          bank[:threshold] = bank[:orig_threshold]
          bank[:threshold] -= bank[:exclude].length
        else
          bank[:exclude] = []
        end

        Rate.transaction do
          items = []
          cnt = 0
          if bank[:script].present? && bank[:script]
            if bank[:script_callback].present? && (defined?(bank[:script_callback]) == "method")
              items = bank[:script_callback].call(page.css(bank[:parent_tag]), bank)
              items.each do |d|
                if bank[:exclude].include? d[0]
                  if check_rates(d[0], d[1], d[2]) # check maybe currency data was fixed so we can turn it on, changing count means threshold will be exceeded
                    cnt += 1
                  end
                else
                  if check_rates(d[0], d[1], d[2])
                    Rate.create_or_update(date, d[0], nil, d[1], d[2], bank[:id])
                    cnt += 1
                  end
                end
              end
            end
          else
            items = (bank[:parent_tag].is_a? Proc) ? bank[:parent_tag].call(page) : page.css(bank[:parent_tag])
            cnt = 0
            items.each do |item|
              c = item.css(bank[:child_tag])
              #pp c.length
              if(c.length == bank[:child_tag_count])
                d = [swap(c[bank[:position][0]].text), n(c[bank[:position][1]].text), n(c[bank[:position][2]].text)]
                if bank[:exclude].include? d[0]
                  if check_rates(d[0], d[1], d[2]) # check maybe currency data was fixed so we can turn it on, changing count means threshold will be exceeded
                    cnt += 1
                  end
                else
                  if check_rates(d[0], d[1], d[2])
                    Rate.create_or_update(date, d[0], nil, d[1], d[2], bank[:id])
                    cnt += 1
                  end
                end
              end
            end
          end
          bank[:cnt] = cnt
          puts "#{bank[:name]} - #{cnt} records"
        end
      rescue  Exception => e
        bank[:cnt] = -1
        bank[:e] = e
        puts "#{bank[:name]} - exception occured"
      end
    end

    # list of all banks id,name,path
    # banks.each do |bank|
    #   puts "#{bank[:id]},#{bank[:name]},#{bank[:path]}"
    # end

    # last phase
    # for types of messages can be sent
    # 1) general report about all bank scrape result (succeeded_list_send variable should be true)
    # 2) unexpected bank currency amount based on each banks threshold value if not equal bank will be added to the list
    # 3) exception while executing bank script if exception will throw
    # 4) sending block throws exception
    begin
      unexpected_behavior_list = []
      exception_list = []
      succeeded_list = []
      succeeded_list_send = false # if we don't need to send each scraper call will be false by default

      banks.each do |bank|
        if bank[:cnt] == -1
          exception_list.push(bank[:name] + " #{bank[:e]}")
        elsif bank[:cnt] != bank[:threshold]
          unexpected_behavior_list.push(bank[:name] + " (#{bank[:cnt]}/#{bank[:threshold]})")
        else
          succeeded_list.push(bank[:name] + " (#{bank[:cnt]})")
        end
      end

      ScraperMailer.exception(exception_list).deliver if exception_list.any?
      ScraperMailer.unexpected(unexpected_behavior_list).deliver if unexpected_behavior_list.any?
      ScraperMailer.report(succeeded_list, unexpected_behavior_list, exception_list).deliver if succeeded_list_send


      returned_banks_list = []
      @returned_banks.each {|bank_id|
        bank = banks.select{|x| x[:id] == bank_id }.first
        if bank.present?
          returned_banks_list.push(bank[:name])
        end
      }
      ScraperMailer.returned_banks(returned_banks_list).deliver if returned_banks_list.any?

    rescue  Exception => e
      ScraperMailer.sending_failed(e).deliver
    end
    #LAST_SCRAPE = Time.now
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
