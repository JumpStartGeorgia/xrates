# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


#####################
## Currencies
#####################
puts "Loading Currenices"
currencyInfo = CSV.open("#{Rails.root}/datafiles/info/data.csv", headers: false).read
created_at = Time.now
ActiveRecord::Base.connection.execute("truncate table currencies")
ActiveRecord::Base.connection.execute("truncate table currency_translations")
sql = "insert into currencies (code, ratio, created_at, updated_at) values "
sql_trans = "insert into currency_translations (currency_id, locale, name, created_at, updated_at) values "
currencyInfo.each_with_index do |t,i|
  sql << "(\"#{t[2]}\", #{t[3]}, \"#{created_at}\", \"#{created_at}\"),"
  sql_trans << "(\"#{i+1}\", \"en\", \"#{t[0]}\", \"#{created_at}\", \"#{created_at}\"),"
  sql_trans << "(\"#{i+1}\", \"ka\", \"#{t[1]}\", \"#{created_at}\", \"#{created_at}\"),"
end
sql[sql.length-1] = ''
sql_trans[sql_trans.length-1] = ''
ActiveRecord::Base.connection.execute(sql)
ActiveRecord::Base.connection.execute(sql_trans)


#####################
## Banks
#####################
puts "Loading Banks"
bankInfo = CSV.open("#{Rails.root}/datafiles/info/banks.csv", headers: false).read
created_at = Time.now
ActiveRecord::Base.connection.execute("truncate table banks")
ActiveRecord::Base.connection.execute("truncate table bank_translations")
sql = "insert into banks (code, buy_color, sell_color, created_at, updated_at, `order`) values "
sql_trans = "insert into bank_translations (bank_id, locale, name, image, created_at, updated_at) values "
bankInfo.each_with_index do |t,i|
  sql << "(\"#{t[0]}\", \"#{t[4]}\", \"#{t[5]}\", \"#{created_at}\", \"#{created_at}\", \"#{t[6]}\"),"
  sql_trans << "(\"#{i+1}\", \"en\", \"#{t[1]}\", \"#{t[3]}\", \"#{created_at}\", \"#{created_at}\"),"
  sql_trans << "(\"#{i+1}\", \"ka\", \"#{t[2]}\", \"#{t[3]}\", \"#{created_at}\", \"#{created_at}\"),"
end
sql[sql.length-1] = ''
sql_trans[sql_trans.length-1] = ''
ActiveRecord::Base.connection.execute(sql)
ActiveRecord::Base.connection.execute(sql_trans)

#####################
## PageContents
#####################
puts "Loading Page Contents"

if PageContent.where(id: 1).blank?
  p = PageContent.create(:id => 1, :name => 'about')
  p.page_content_translations.create(:locale => 'en', :title => 'About', :content => '<p>
Between November 2014 and February 2015, the lari depreciated by 18.8%. While it is unclear exactly why the lari is depreciated, it is clear that the unstable nature of the lari is having an impact on peoples lives. During that same period, the net worth of every 1,000 lari decreased from 558 USD to 456 USD, or a total of 102 USD. While we don\'t currently have data describing the number of people who have loans, most loans are tied to the dollar and most people\'s salaries are in lari. This is making it incredibly difficult for people to make their scheduled mortgage and other loan payments, among other difficulties.
</p>
<p>
The Lari Explorer is the evolution of our <a href="http://feradi.info/en/visualizations/the-celery-1-the-pilot-the-georgian-champion">comic</a> and previous <a href="http://feradi.info/en/visualizations/jumpstarts-winter-2014-2015-lari-depreciation-calculator">Winter 2014-2015 Lari Depreciation Calculator</a> and adds more features for people to explore changes in the lari over a period of their choosing and compare those changes with other currencies. It pulls the lastest data from the <a href="https://www.nbg.gov.ge/index.php?m=2&lng=eng">National Bank of Georgia</a> on a nightly basis. 
</p>
<p>
Similarly, we are pulling in exchange data from four banks, but intend to increase that number soon. By aggregating bank exchange rates in one place, we hope to make it easier for people to compare them and more easily make better decisions. In the future, we will strive to continue to add more banks and improve the relevancy of this component of the Lari Explorer.
</p>
<p>
For you programmers out there, we have exposed the data via an open <a href="/en/api">API</a> and you are welcome to use it. We\'d love to hear from you on why and how you are using the API and what we can do to make this service better.
</p>
<p>
If you\'d like to learn more about this and other JumpStart tools, please don\'t hesitate to <a href="http://jumpstart.ge/en/contact-us">contact us!</a> We\'d love to hear and collaborate with you.
</p>
<p>
In the end, data is what you make of it!
</p>
')
  p.page_content_translations.create(:locale => 'ka', :title => "About", :content => '<p>
2014 წლის ნოემბრიდან 2015 წლის თებერვლამდე ლარის ღირებულება აშშ დოლართან მიმართებაში 18.8%-ით შემცირდა. ლარის ღირებულების დაცემის ზუსტი მიზეზები გაურკვეველია, თუმცა ცხადია, რომ ლარის არასტაბილური მდგომარეობა ადამიანების ცხოვრებაზე გავლენას ახდენს. ამ პერიოდში ათასი ლარის ღირებულება ამერიკულ დოლარში 102 დოლარით შემცირდა. არ გვაქვს მონაცემები, რამდენ ადამიანს აქვს ბანკის ვალი, თუმცა ცნობილია, რომ იპოთეკური თუ სხვა სესხების უმეტესობა აშშ დოლარშია, ხალხს კი შემოსავალი ლარში აქვს. ყველა სხვა სირთულესთან ერთად, ეს ძალიან ართულებს მათთვის საკუთარი ფინანსური ვალდებულებების შესრულებას. 
</p>
<p>
ლარის გზამკვლევი განვითარდა ჩვენი <a href="http://feradi.info/ka/visualizations/niakhuri-1-piloti-qartveli-palavani">კომიქსისა </a> და წინა <a href="http://feradi.info/ka/visualizations/2014-2015-tslis-zamtarshi-laris-gaupasurebis-kalkulatori">ლარის გაუფასურების კალკულატორის </a> შედეგად. იგი მომხმარებლებს ახალ ფუნქციებს სთავაზობს, რომელთა საშუალებითაც შესაძლებელია მათთვის საინტერესო დროის მონაკვეთში ლარის ღირებულების ცვლილებების ნახვა სხვადასხვა ვალუტასთან მიმართებით. მონაცემები აღებულია <a href="https://www.nbg.gov.ge/index.php?m=2&lng=geo">საქართველოს ეროვნული ბანკის</a> საიტიდან და განახლდება ყოველდღიურად. 
</p>
<p>
ასევე, ვალუტის კურსის მონაცემებს ვაგროვებთ ოთხი ბანკის საიტიდან, თუმცა ვგეგმავთ მათი რაოდენობის გაზრდას. კომერციული ბანკების ვალუტის გაცვლის კურსების ერთ ადგილას თავმოყრით, გვინდა, ხალხს გავუადვილოთ მათი შედარება და უკეთესი გადაწყვეტილებების მიღება. სამომავლოდ გვსურს კომერციული ბანკების გვერდს ვალუტის კურსების არქივიც დავამატოთ, რათა მომხმარებელს ისტორიული პერსპექტივის დანახვის საშუალებაც მიეცეს. 
</p>
<p>
პროგრამისტებო, თქვენთვის მონაცემები ხელმისაწვდომი გავხადეთ <a href="/ka/api">API</a>-ის საშუალებით და მივესალმებით მის გამოყენებას. გვსურს, თქვენგან გავიგოთ რისთვის და როგორ იყენებთ და შეგვიძლია თუ არა მისი კიდევ უფრო გაუმჯობესება.  
</p>
<p>
თუ გსურთ, მეტი გაიგოთ ლარის გზამკვლევისა და ჯამპსტარტის სხვა ხელსაწყოების შესახებ, <a href="http://jumpstart.ge/ka/contact-us">დაგვიკავშირდით !</a> 
</p>
<p>
საბოლოო ჯამში, მონაცემების მნიშვნელობას ის განსაზღვრავს, თუ რა გამოყენებას მოუნახავთ მას! 
</p>
')
end
if PageContent.where(id: 2).blank?
  p = PageContent.create(:id => 2, :name => 'api')
  p.page_content_translations.create(:locale => 'en', :title => 'Lari Explorer API', :content => '<p>The Lari Explorer API allows you to obtain information about the National Bank of Georgia’s currency rates, buy and sell rates of commercial banks operating in Georgia and other related information, as seen on the Lari Explorer website.</p>
  <h2>The URL to the API is the following:</h2>
  <div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/[version]/</div>
  <p>where:</p>
  <ul class="list-unstyled">
  <li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
  <li>[version] = the version number of the API (see below)</li>
  </ul>
  <h2>API Calls</h2>
  <p>The following is a list of calls that are available in each version of the API.</p>')
  p.page_content_translations.create(:locale => 'ka', :title => 'ლარის გზამკვლევის API', :content => '<p>ლარის გზამკვლევის API საშუალებას გაძლევთ მიიღოთ ინფორმაცია საქართველოს ეროვნული ბანკის სავალუტო კურსის შესახებ, საქართველოში მოქმედი კომერციული ბანკების მიერ ვალუტის ყიდვა და გაყიდვისა და სხვა მასთან დაკავშირებული ინფორმაციების შესახებ, რომლებიც მოცემულია ლარის გზამკვლევის ვებ-გვერდზე.
</p>
<h2>API-ის აპლიკაციის URL:</h2>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/[version]/</div>
<p>სადაც:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად) </li>
<li>[version] = API-ის ვერსიის ნომერი (იხილეთ ქვემოთ)</li>
</ul>
<h2>API-ის გამოძახება</h2>
<p>ქვემოთ მოცემული სია წარმოადგენს გამოძახიების სიას რომელიც ხელმისაწვდომია API-ს თითოეული ვერსიისთვის.</p>')
end

#####################
## Create API Versions/Methods
#####################
puts 'Creating API Versions/Methods'
v = ApiVersion.by_permalink('v1')
if v.blank?
  v = ApiVersion.create(permalink: 'v1', public: true)
  v.api_version_translations.create(locale: 'en', title: 'Version 1')
  v.api_version_translations.create(locale: 'ka', title: 'ვერსია 1')
end
if v.present? && v.api_methods.empty?
  m = v.api_methods.create(permalink: 'nbg_currencies', sort_order: 1, public: true)
  m.api_method_translations.create(locale: 'en', title: 'National Bank of Georgia Currencies', content: '<p>Get a list of the foreign currencies the National Bank of Georgia has suggested exchange rates for against the Lari.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/nbg_currencies</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
</ul>
<h2>Required Parameters</h2>
<p>There are no required parameters for this call. </p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters for this call. </p>
<h2>What You Get</h2>
<p>The return object is a JSON array of currencies with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>code</td>
<td>The code of the currency</td>
</tr>
<tr>
<td>name</td>
<td>The name of the currency</td>
</tr>
<tr>
<td>ratio</td>
<td>The number of this currency to 1 Lari (e.g., 1 USD to 1 Lari)</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of getting all currencies being tracked by the National Bank of Georgia. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/nbg_currencies" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_currencies</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  results: [
    {
      code: "EUR",
      name: "Euro",
      ratio: 1
    },
    {
      code: "GBP",
      name: "Pound Sterling",
      ratio: 1
    },
    {
      code: "RUB",
      name: "Russian Ruble",
      ratio: 100
    },
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1
    }
  ]
}</pre>
<p> </p>')
  m.api_method_translations.create(locale: 'ka', title: 'საქართველოს ეროვნული ბანკის კურსი', content: '<p>გაეცანით საქართველოს ეროვნული ბანკის მიერ დადგენილ უცხოური ვალუტების გაცვლით კურსს ლართან მიმართებაში.</p>
<h2><strong>URL</strong></h2>
<p>ამ მეთოდის გამოძახებისთვის გამოიყენეთ HTTP GET მოთხოვნა შემდეგი URL-სთვის:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/nbg_currencies</div>
<p>სად:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
</ul>
<h2><strong>აუცილებელი პარამეტრები</strong></h2>
<p>გამოძახებისთვის არ არის საჭირო აუცილებელი პარამეტრები.</p>
<h2><strong>არჩევითი პარამეტრები</strong></h2>
<p>გამოძახებისთვის არ არის საჭირო არჩევითი &nbsp;პარამეტრები.</p>
<h2><strong>რას მიიღებთ</strong></h2>
<p>დაბრუნებული ობიექტი იქნება ვალუტებით შემდგარი JSON მასივი შემდეგი ინფორმაციით:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
code
</td>
<td>
ვალუტის კოდი
</td>
</tr>
<tr>
<td>
name
</td>
<td>
ვალუტის სახელი
</td>
</tr>
<tr>
<td>
ratio
</td>
<td>
ვალუტის ნომერი 1 ლართან მიმართებაში (მაგ., 1 აშშ დოლარიდან 1 ლარში)
</td>
</tr>
</tbody>
</table>
<h2>მაგალითები</h2>
<h3>მაგალითი 1</h3>
<p>აქ მოცემულია ყველა ვალუტის მიღების მაგალითი, რომელიც მიღებულია ერონული ბანკიდან. URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/nbg_currencies" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_currencies</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  results: [
    {
      code: "EUR",
      name: "Euro",
      ratio: 1
    },
    {
      code: "GBP",
      name: "Pound Sterling",
      ratio: 1
    },
    {
      code: "RUB",
      name: "Russian Ruble",
      ratio: 100
    },
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1
    }
  ]
}</pre>
<p>&nbsp;</p>')

  m = v.api_methods.create(permalink: 'nbg_rates', sort_order: 2, public: true)
  m.api_method_translations.create(locale: 'en', title: 'National Bank of Georgia Rates', content: '<p>Get Lari exchange rates from the National Bank of Georgia for one or more currencies.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/nbg_rates</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
</ul>
<h2>Required Parameters</h2>
<p>The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>The code of the currency to get exchange rates for. Can provide one currency code (e.g., USD) or a comma separated list (e.g., USD,EUR,GBP).</td>
</tr>
</tbody>
</table>
<p> </p>
<h2>Optional Parameters</h2>
<p>There following parameters are optional and can be used to help limit the data that is desired. At this time, both the start_date and end_date must be provided in order for the date filters to be applied. If no dates are provided, all exchange rates on file will be returned.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>start_date</td>
<td>The date to start getting exchange rates, in UTC format (e.g., 1422748800000 is the UTC date for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop getting exchange rates, in UTC format (e.g., 1422748800000 is the UTC date for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<h2>What You Get</h2>
<p>The return object is a JSON array of currencies and their exchange rates with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>code</td>
<td>The code of the currency</td>
</tr>
<tr>
<td>name</td>
<td>The name of the currency</td>
</tr>
<tr>
<td>ratio</td>
<td>The number of this currency to 1 Lari (e.g., 1 USD to 1 Lari)</td>
</tr>
<tr>
<td>rates</td>
<td>An array of exchange rates between the requested dates, or all rates on file if no dates are provided</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of getting all exchange rates on file for the U.S. Dollar. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/nbg_rates?currency=USD" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  result: [
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1,
      rates: [
        [
          1420070400000,
          1.8821
        ],
        [
          1420156800000,
          1.8821
        ],
        [
          1420243200000,
          1.8821
        ]
      ]
    }
  ]
}</pre>

<h3>Example 2</h3>
<p>Here is an example of getting all exchange rates on file for the U.S. Dollar between 2014-01-01 and 2015-01-01. The URL for this is the following (remember dates must be converted into <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC dates</a>):</p>
<div class="url"><a href="/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  result: [
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1,
      rates: [
        [
          1391212800000,
          1.7824
        ],
        [
          1391299200000,
          1.7824
        ],
        [
          1391385600000,
          1.7824
        ]
      ]
    }
  ]
}</pre>
<h3>Example 3</h3>
<p>Here is an example of getting all exchange rates on file for the U.S. Dollar and Pound Sterling. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/nbg_rates?currency=USD,GBP" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD,GBP</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  result: [
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1,
      rates: [
        [
          1420070400000,
          1.8821
        ],
        [
          1420156800000,
          1.8821
        ],
        [
          1420243200000,
          1.8821
        ]
      ]
    },
    {
      code: "GBP",
      name: "Pound Sterling",
      ratio: 1,
      rates: [
        [
          1420070400000,
          2.922
        ],
        [
          1420156800000,
          2.922
        ],
        [
          1420243200000,
          2.922
        ]
      ]
    }
  ]
}</pre><p> </p>')

  m.api_method_translations.create(locale: 'ka', title: 'საქართველოს ეროვნული ბანკის კურსები', content: '<p>საქართველოს ეროვნული ბანკიდან ლარის გაცვლით კურსის მიღება ერთი ან რამდენიმე ვალუტისთვის.</p>
<h2>URL</h2>
<p>ამ მეთოდის გამოძახებისთვის გამოიყენეთ HTTP GET მოთხოვნა შემდეგი URL-სთვის:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/nbg_rates</div>
<p>სად:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
</ul>
<h2>აუცილებელი პარამეტრები</h2>
<p>მოთხოვნა უნდა შეიცავდეს შემდეგ პარამეტრებს:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tbody>
<tr>
<td>
currency 
</td>
<td>
ვალუტის კოდი გაცვლითი კურსის მისაღებად. შეიძლება მოწოდებული იყოს ერთი ვალუტის კოდი (მაგ., USD) ან ერთობლივად განცალკევებული სიით (მაგ., USD,EUR,GBP).
</td>
</tr>
</tbody>
</table>
<h2>არჩევითი პარამეტრები</h2>
<p>მოცემული პარამეტრები არჩევითია და შეიძლება გამოყენბეულ იქნეს სასურველი მონაცემების შესამცირებლად. ამ შემთხვევაში ორივე საწყისი_თარიღი და დასასრულის_თარიღი უნდა იქნეს მოცემული რათა მოხდეს თარიღების ფილტრაცია. თუ თარიღები არ იქნება მოცემული, ყველა გაცვლითი კურსი დაბრუნდება.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
start_date 
</td>
<td>
გაცვლითი კურსის ინფორმაციის მიღების საწყისი თარიღი, UTC ფორმატში (მაგ., 1422748800000 არის UTC თარიღი 2015-01-01-სთვის) <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC-ს თარიღების შესახებ დამატებითი ინფორმაციის მიღება შესაძლებელია ამ ბმულზე.</a>
</td>
</tr>
<tr>
<td>
end_date 
</td>
<td>
გაცვლითი კურსის ინფორმაციის მიღების ბოლო თარიღი, UTC ფორმატში (მაგ., 1422748800000 არის UTC თარიღი 2015-01-01-სთვის) <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC-ს თარიღების შესახებ დამატებითი ინფორმაციის მიღება შესაძლებელია ამ ბმულზე.</a>
</td>
</tr>
</tbody>
</table>
<h2>რას მიიღებთ</h2>
<p>დაბრუნებული ობიექტი იქნება ვალუტებით შემდგარი JSON მასივი შემდეგი ინფორმაციით:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
code 
</td>
<td>
ვალუტის კოდი
</td>
</tr>
<tr>
<td>
name 
</td>
<td>
ვალუტის სახელი
</td>
</tr>
<tr>
<td>
ratio 
</td>
<td>
ვალუტის ნომერი 1 ლართან მიმართებაში (მაგ., 1 USD-დან &nbsp;1 GEL-ში)
</td>
</tr>
<tr>
<td>
rates 
</td>
<td>
გაცვლითი კურსის მასივი მოთხოვნილი თარიღების შუალედში, ან თუ თარიღები არ არის მოთხოვნილი, ფაილში არსებული ყველა კურსისთვის.
</td>
</tr>
</tbody>
</table>
<h2>მაგალითები</h2>
<h3>მაგალითი 1</h3>
<p>აქ მოცემულია ფაილში არსებული ყველა ვალუტის მიღების მაგალითი აშშ დოლართან მიმართებაში. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/nbg_rates?currency=USD" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  result: [
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1,
      rates: [
        [
          1420070400000,
          1.8821
        ],
        [
          1420156800000,
          1.8821
        ],
        [
          1420243200000,
          1.8821
        ]
      ]
    }
  ]
}</pre>

<h3>მაგალითი 2</h3>
<p>აქ მოცემულია ფაილში არსებული ყველა ვალუტის მიღების მაგალითი აშშ დოლართან მიმართებაში 2014-01-01 - 2015-01-01 პერიოდში. მისი URL არის შემდეგი (დაიმახსოვრეთ, თარიღები უნდა იქნას გადაყვანილი <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC ფორმატში</a>):</p>
<div class="url"><a href="/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  result: [
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1,
      rates: [
        [
          1391212800000,
          1.7824
        ],
        [
          1391299200000,
          1.7824
        ],
        [
          1391385600000,
          1.7824
        ]
      ]
    }
  ]
}</pre>

<h3>მაგალითი 3</h3>
<p>აქ მოცემულია ფაილში არსებული ყველა ვალუტის მიღების მაგალითი აშშ დოლართან და ფუნტ სტერლინგთან მიმართებაში. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/nbg_rates?currency=USD,GBP" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD,GBP</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  result: [
    {
      code: "USD",
      name: "US Dollar",
      ratio: 1,
      rates: [
        [
          1420070400000,
          1.8821
        ],
        [
          1420156800000,
          1.8821
        ],
        [
          1420243200000,
          1.8821
        ]
      ]
    },
    {
      code: "GBP",
      name: "Pound Sterling",
      ratio: 1,
      rates: [
        [
          1420070400000,
          2.922
        ],
        [
          1420156800000,
          2.922
        ],
        [
          1420243200000,
          2.922
        ]
      ]
    }
  ]
}</pre>
<p>&nbsp;</p>')


  m = v.api_methods.create(permalink: 'commercial_banks', sort_order: 3, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Commercial Banks', content: '<p>Get a list of the commercial banks whose buy and sell exchange rates are being tracked. For each bank, a list of currencies each bank is exchanging is also provided.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/commercial_banks</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
</ul>
<h2>Required Parameters</h2>
<p>There are no required parameters for this call. </p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters for this call. </p>
<h2>What You Get</h2>
<p>The return object is a JSON array of banks with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>code</td>
<td>The code of the bank</td>
</tr>
<tr>
<td>name</td>
<td>The name of the bank</td>
</tr>
<tr>
<td>currencies</td>
<td>An array of currency codes that the bank is exchanging</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of getting all banks being tracked by this site. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/commercial_banks" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_banks</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  results: [
    {
      code: "REPL",
      name: "Bank Republic",
      currencies: [
          "EUR",
          "GBP",
          "RUB",
          "USD"
      ]
    },
    {
      code: "LBRT",
      name: "Liberty Bank",
      currencies: [
          "AMD",
          "AZN",
          "CHF",
          "EUR",
          "GBP",
          "RUB",
          "TRY",
          "USD"
      ]
    }
  ]
}</pre>
<p> </p>')
  m.api_method_translations.create(locale: 'ka', title: 'კომერციული ბანკები', content: '<p>შესაძლებელია იმ კომერციული ბანკების სიის მიღება, რომლების ყიდვა-გაყიდვის მონაცემებიც მოპოვებულია. თითოეული ბანკისთვის, აგრეთვე მოცემულია იმ ყველა ვალუტის სია, რომელსაც თითოეული ბანკი ცვლის.</p>
<h2>URL</h2>
<p>ამ მეთოდის გამოძახებისთვის გამოიყენეთ HTTP GET მოთხოვნა შემდეგი URL-სთვის:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/commercial_banks</div>
<p>სად:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
</ul>
<h2>აუცილებელი პარამეტრები</h2>
<p>გამოძახებისთვის არ არის საჭირო აუცილებელი პარამეტრები.</p>
<h2>არჩევითი პარამეტრები</h2>
<p>გამოძახებისთვის არ არის საჭირო არჩევითი &nbsp;პარამეტრები.</p>
<h2>რას მიიღებთ</h2>
<p>დაბრუნებული ობიექტი იქნება ბანკებით შემდგარი JSON მასივი შემდეგი ინფორმაციით</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
code
</td>
<td>
ბანკის კოდი
</td>
</tr>
<tr>
<td>
name
</td>
<td>
ბანკის სახელი
</td>
</tr>
<tr>
<td>
currencies
</td>
<td>
კურსების კოდების მასივი, რომელსაც ბანკი ცვლის
</td>
</tr>
</tbody>
</table>
<h2>მაგალითები</h2>
<h3>მაგალითი 1</h3>
<p>აქ მოცემულია საიტიზე არსებული ყველა ბანკის მიღების მაგალითი. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/commercial_banks" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_banks</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  results: [
    {
      code: "REPL",
      name: "Bank Republic",
      currencies: [
          "EUR",
          "GBP",
          "RUB",
          "USD"
      ]
    },
    {
      code: "LBRT",
      name: "Liberty Bank",
      currencies: [
          "AMD",
          "AZN",
          "CHF",
          "EUR",
          "GBP",
          "RUB",
          "TRY",
          "USD"
      ]
    }
  ]
}</pre>
<p>&nbsp;</p>')

  m = v.api_methods.create(permalink: 'commercial_banks_with_currency', sort_order: 4, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Commercial Banks with Currency', content: '<p>Get a list of the commercial banks whose exchange a particular currency. </p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/commercial_banks_with_currency</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
</ul>
<h2>Required Parameters</h2>
<p>The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>The code of the currency to see which banks are exchanging</td>
</tr>
</tbody>
</table>
<h2>Optional Parameters</h2>
<p>There are no optional parameters for this call. </p>
<h2>What You Get</h2>
<p>The return object is a JSON array of banks with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>code</td>
<td>The code of the bank</td>
</tr>
<tr>
<td>name</td>
<td>The name of the bank</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of getting all banks that exchange the U.S. Dollar. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/commercial_banks_with_currency?currency=USD" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_banks_with_currency?currency=USD</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  results: [
    {
      code: "BAGA",
      name: "Bank Of Georgia"
    },
    {
      code: "TBCT",
      name: "TBCT Bank"
    },
    {
      code: "REPL",
      name: "Bank Republic"
    },
    {
      code: "LBRT",
      name: "Liberty Bank"
    }
  ]
}</pre>
<p> </p>')
  m.api_method_translations.create(locale: 'ka', title: 'კომერციული ბანკები ვალუტებით', content: '<p>იმ კომერციული ბანკების სიის მიღება, რომლებიც ცვლიან კონკრეტულ ვალუტებს.</p>
<h2>URL</h2>
<p>ამ მეთოდის გამოძახებისთვის გამოიყენეთ HTTP GET მოთხოვნა შემდეგი URL-სთვის:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/commercial_banks_with_currency</div>
<p>სად:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
</ul>
<h2>აუცილებელი პარამეტრები</h2>
<p>მოთხოვნა უნდა შეიცავდეს შემდეგ პარამეტრებს:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
currency
</td>
<td>
ვალუტის კოდი რათა ვნახოთ რომელი ბანკები ცვლიან მას
</td>
</tr>
</tbody>
</table>
<h2>არჩევითი პარამეტრები</h2>
<p>გამოძახებისთვის არ არის საჭირო არჩევითი &nbsp;პარამეტრები.</p>
<h2>რას მიიღებთ</h2>
<p>დაბრუნებული ობიექტი იქნება ვალუტებით შემდგარი JSON მასივი შემდეგი ინფორმაციით:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
code
</td>
<td>
ბანკის კოდი
</td>
</tr>
<tr>
<td>
name
</td>
<td>
ბანკის სახელი
</td>
</tr>
</tbody>
</table>
<h2>მაგალითები</h2>
<h3>მაგალითი 1</h3>
<p>მაგალითისთვის მოცემულია იმ ყველა ბანკის მიღება რომელიც ცვლის USD-ს. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/commercial_banks_with_currency?currency=USD" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_banks_with_currency?currency=USD</a></div>
<pre class="brush:js;auto-links:false;toolbar:false;tab-size:2" contenteditable="false">{
  valid: true,
  results: [
    {
      code: "BAGA",
      name: "Bank Of Georgia"
    },
    {
      code: "TBCT",
      name: "TBCT Bank"
    },
    {
      code: "REPL",
      name: "Bank Republic"
    },
    {
      code: "LBRT",
      name: "Liberty Bank"
    }
  ]
}</pre>
<p> </p>
')


  m = v.api_methods.create(permalink: 'commercial_bank_rates', sort_order: 5, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Commercial Bank Rates', content: '<p>Get commercial bank\'s buy and sell exchange rates for a currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/commercial_bank_rates</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
</ul>
<h2>Required Parameters</h2>
<p>The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>
<p>The code of the currency to get exchange rates for (e.g., USD)</p>
</td>
</tr>
<tr>
<td>bank</td>
<td>The code of the bank to get exchange rates from. Can provide one bank code (e.g., BAGA) or a comma separated list (e.g., BAGA,TBCT)</td>
</tr>
</tbody>
</table>
<p> </p>
<h2>Optional Parameters</h2>
<p>There following parameters are optional and can be used to help limit the data that is desired. At this time, both the start_date and end_date must be provided in order for the date filters to be applied. If no dates are provided, all exchange rates on file will be returned.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>start_date</td>
<td>The date to start getting exchange rates for, in UTC format (e.g., 1422748800000 is the UTC date for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop getting exchange rates for, in UTC format (e.g., 1422748800000 is the UTC date for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<h2>What You Get</h2>
<p>The return object is a JSON array of currencies and their exchange rates with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>id</td>
<td>A combination of the bank code, currency code and if the <strong>data</strong> represents the buy or sell rates</td>
</tr>
<tr>
<td>code</td>
<td> The code of the bank</td>
</tr>
<tr>
<td>name</td>
<td>The name of the bank</td>
</tr>
<tr>
<td> currency</td>
<td> The code of the currency</td>
</tr>
<tr>
<td>rate_type</td>
<td> Indicates if the rates in <strong>data</strong> are for buying or selling. Possible values are: buy, sell.</td>
</tr>
<tr>
<td>color</td>
<td> The color to use for this bank in the chart</td>
</tr>
<tr>
<td>dashStyle</td>
<td> The dash style to use for this data in the chart</td>
</tr>
<tr>
<td>legendIndex</td>
<td> The legend index for this band in the chart</td>
</tr>
<tr>
<td>data</td>
<td>An array of exchange rates between the requested dates, or all rates on file if no dates are provided</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of getting the buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  result: [
    {
      id: "BAGA_USD_B",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "buy",
      color: "#FAA43A",
      dashStyle: "shortdot",
      legendIndex: 2,
      data: [
        [
          1426723200000,
          2.187000036239624
        ],
        [
          1426809600000,
          2.191999912261963
        ],
        [
          1426896000000,
          2.191999912261963
        ]
      ]
    },
    {
      id: "BAGA_USD_S",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "sell",
      color: "#FAA43A",
      dashStyle: "shortdash",
      legendIndex: 3,
      data: [
        [
          1426723200000,
          2.246999979019165
        ],
        [
          1426809600000,
          2.252000093460083
        ],
        [
          1426896000000,
          2.252000093460083
        ]      
      ]
    }
  ]
}</pre>
<h3>Example 2</h3>
<p>Here is an example of getting the buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia between 2014-01-01 and 2015-01-01. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  result: [
    {
      id: "BAGA_USD_B",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "buy",
      color: "#FAA43A",
      dashStyle: "shortdot",
      legendIndex: 2,
      data: [
        [
          1426723200000,
          2.187000036239624
        ],
        [
          1426809600000,
          2.191999912261963
        ],
        [
          1426896000000,
          2.191999912261963
        ]
      ]
    },
    {
      id: "BAGA_USD_S",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "sell",
      color: "#FAA43A",
      dashStyle: "shortdash",
      legendIndex: 3,
      data: [
        [
          1426723200000,
          2.246999979019165
        ],
        [
          1426809600000,
          2.252000093460083
        ],
        [
          1426896000000,
          2.252000093460083
        ]
      ]
    }
  ]
}</pre>
<h3>Example 3</h3>
<p>Here is an example of getting the buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia and TBCT Bank. The URL for this is the following:</p>
<div class="url"><a href="/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCT" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCT</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  result: [
    {
      id: "BAGA_USD_B",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "buy",
      color: "#FAA43A",
      dashStyle: "shortdot",
      legendIndex: 2,
      data: [
        [
          1426723200000,
          2.187000036239624
        ],
        [
          1426809600000,
          2.191999912261963
        ],
        [
          1426896000000,
          2.191999912261963
        ]
      ]
    },
    {
      id: "BAGA_USD_S",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "sell",
      color: "#FAA43A",
      dashStyle: "shortdash",
      legendIndex: 3,
      data: [
        [
          1426723200000,
          2.246999979019165
        ],
        [
          1426809600000,
          2.252000093460083
        ],
        [
          1426896000000,
          2.252000093460083
        ]      
      ]
    },
    {
      id: "TBCT_USD_B",
      code: "TBCT",
      name: "TBCT Bank (TBCT)",
      currency: "USD",
      rate_type: "buy",
      color: "#60BD68",
      dashStyle: "shortdot",
      legendIndex: 4,
      data: [
        [
          1426723200000,
          2.190000057220459
        ],
        [
          1426809600000,
          2.184999942779541
        ],
        [
          1426896000000,
          2.184999942779541
        ]
      ]
    },
    {
      id: "TBCT_USD_S",
      code: "TBCT",
      name: "TBCT Bank (TBCT)",
      currency: "USD",
      rate_type: "sell",
      color: "#60BD68",
      dashStyle: "shortdash",
      legendIndex: 5,
      data: [
        [
          1426723200000,
          2.25
        ],
        [
          1426809600000,
          2.244999885559082
        ],
        [
          1426896000000,
          2.244999885559082
        ]
      ]
    }  
  ]
}</pre>
<p> </p>
')
  m.api_method_translations.create(locale: 'ka', title: 'კომერციული ბანკის კურსები', content: '<p>შესაძლებელია კომერციული ბანკების მიერ დადგენილი ვალუტის ყიდვისა და გაყიდვის კურსების მიღება. შედარებისთვის, საქართველოს ეროვნული ბანკის მიერ შეთავაზებული სავალუტო კურსები აგრეთვე დაბრუნდება.</p>
<h2>URL</h2>
<p>ამ მეთოდის გამოძახებისთვის გამოიყენეთ HTTP GET მოთხოვნა შემდეგი URL-სთვის:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/commercial_bank_rates</div>
<p>სად:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
</ul>
<h2>აუცილებელი პარამეტრები</h2>
<p>მოთხოვნა უნდა შეიცავდეს შემდეგ პარამეტრებს:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
currency
</td>
<td>
ვალუტის კოდი რათა მიიღოთ ინფორმაცია გაცვლითი კურსის შესახებ (მაგ. USD)
</td>
</tr>
<tr>
<td>
bank
</td>
<td>
იმ ბანკის კოდი, საიდანაც ვიღებთ გაცვლით კურსს. შეიძლება მოცემული იყოს ერთი ბანკის კოდი (მაგ. BAGA) ან ერთობლივად განცალკევებული სიით (მაგ., BAGA,TBCT)
</td>
</tr>
</tbody>
</table>
<h2>არჩევითი პარამეტრები</h2>
<p>მოცემული პარამეტრები არჩევითია და შეიძლება გამოყენბეულ იქნეს სასურველი მონაცემების შესამცირებლად. ამ შემთხვევაში ორივე საწყისი_თარიღი და დასასრულის_თარიღი უნდა იქნეს მოცემული რათა მოხდეს თარიღების ფილტრაცია. თუ თარიღები არ იქნება მოცემული, ყველა გაცვლითი კურსი დაბრუნდება.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
start_date
</td>
<td>
გაცვლითი კურსის ინფორმაციის მიღების საწყისი თარიღი, UTC ფორმატში (მაგ., 1422748800000 არის UTC თარიღი 2015-01-01-სთვის) <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC-ს თარიღების შესახებ დამატებითი ინფორმაციის მიღება შესაძლებელია ამ ბმულზე.</a>
</td>
</tr>
<tr>
<td>
end_date
</td>
<td>
გაცვლითი კურსის ინფორმაციის მიღების ბოლო თარიღი, UTC ფორმატში (მაგ., 1422748800000 არის UTC თარიღი 2015-01-01-სთვის) <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC-ს თარიღების შესახებ დამატებითი ინფორმაციის მიღება შესაძლებელია ამ ბმულზე</a>.
</td>
</tr>
</tbody>
</table>
<h2>რას მიიღებთ</h2>
<p>დაბრუნებული ობიექტი იქნება ვალუტებით შემდგარი JSON მასივი შემდეგი ინფორმაციით:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
id
</td>
<td>
ბანკის კოდის, ვალუტის კოდისა და თუ <strong>data</strong> მოიპოვება ყიდვა-გაყიდვის კურსების კომბინაცია
</td>
</tr>
<tr>
<td>
code
</td>
<td>
ბანკის კოდი
</td>
</tr>
<tr>
<td>
name
</td>
<td>
ბანკის სახელი
</td>
</tr>
<tr>
<td>
currency
</td>
<td>
ვალუტის კოდი
</td>
</tr>
<tr>
<td>
rate_type
</td>
<td>
<strong>data-ში</strong> მითითებული კურსი მოცემულია გაყიდვის ან ყიდვის ფორმატში. შესაძლო ღირებულებებია: გაყიდვა, ყივა.
</td>
</tr>
<tr>
<td>
color
</td>
<td>
ფერი, რომელიც გამოყენებულია ცხრილში ბანკის აღსანიშნად.
</td>
</tr>
<tr>
<td>
dashStyle
</td>
<td>
ხაზების სტილის გამოყენება ცხრილში არსებული მონაცემებისთვის.
</td>
</tr>
<tr>
<td>
legendIndex
</td>
<td>
ლეგენდის ინდექსი ცხრილში მოცემული ჯგუფებისთვის
</td>
</tr>
<tr>
<td>
data
</td>
<td>
გაცვლითი კურსის მასივი მოთხოვნილი თარიღების შუალედში, ან თუ თარიღები არ არის მოთხოვნილი, ფაილში არსებული ყველა კურსისთვის.
</td>
</tr>
</tbody>
</table>
<h2>მაგალითები</h2>
<h3>მაგალითი 1</h3>
<p>მაგალითისთვის მოცემულია საქართველოს ბანკის მიერ დადგენილი ყიდვა-გაყიდვის კურსის მიღება USD-თან მიმართებაში. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  result: [
    {
      id: "BAGA_USD_B",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "buy",
      color: "#FAA43A",
      dashStyle: "shortdot",
      legendIndex: 2,
      data: [
        [
          1426723200000,
          2.187000036239624
        ],
        [
          1426809600000,
          2.191999912261963
        ],
        [
          1426896000000,
          2.191999912261963
        ]
      ]
    },
    {
      id: "BAGA_USD_S",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "sell",
      color: "#FAA43A",
      dashStyle: "shortdash",
      legendIndex: 3,
      data: [
        [
          1426723200000,
          2.246999979019165
        ],
        [
          1426809600000,
          2.252000093460083
        ],
        [
          1426896000000,
          2.252000093460083
        ]      
      ]
    }
  ]
}</pre>

<h3>მაგალითი 2</h3>
<p>მაგალითისთვის მოცემულია საქართველოს ბანკის მიერ დადგენილი ყიდვა-გაყიდვის კურსის მიღება USD-თან მიმართებაში 2014-01-01 - 2015-01-01 პერიოდში. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  result: [
    {
      id: "BAGA_USD_B",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "buy",
      color: "#FAA43A",
      dashStyle: "shortdot",
      legendIndex: 2,
      data: [
        [
          1426723200000,
          2.187000036239624
        ],
        [
          1426809600000,
          2.191999912261963
        ],
        [
          1426896000000,
          2.191999912261963
        ]
      ]
    },
    {
      id: "BAGA_USD_S",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "sell",
      color: "#FAA43A",
      dashStyle: "shortdash",
      legendIndex: 3,
      data: [
        [
          1426723200000,
          2.246999979019165
        ],
        [
          1426809600000,
          2.252000093460083
        ],
        [
          1426896000000,
          2.252000093460083
        ]
      ]
    }
  ]
}</pre>
<h3>მაგალითი 3</h3>
<p>მაგალითისთვის მოცემულია საქართველოს ბანკისა და თიბისი ბანკის მიერ დადგენილი ყიდვა-გაყიდვის კურსების მიღება USD-თან მიმართებაში. მისი URL არის შემდეგი:</p>
<div class="url"><a href="/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCT" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCT</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  result: [
    {
      id: "BAGA_USD_B",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "buy",
      color: "#FAA43A",
      dashStyle: "shortdot",
      legendIndex: 2,
      data: [
        [
          1426723200000,
          2.187000036239624
        ],
        [
          1426809600000,
          2.191999912261963
        ],
        [
          1426896000000,
          2.191999912261963
        ]
      ]
    },
    {
      id: "BAGA_USD_S",
      code: "BAGA",
      name: "Bank Of Georgia (BAGA)",
      currency: "USD",
      rate_type: "sell",
      color: "#FAA43A",
      dashStyle: "shortdash",
      legendIndex: 3,
      data: [
        [
          1426723200000,
          2.246999979019165
        ],
        [
          1426809600000,
          2.252000093460083
        ],
        [
          1426896000000,
          2.252000093460083
        ]      
      ]
    },
    {
      id: "TBCT_USD_B",
      code: "TBCT",
      name: "TBCT Bank (TBCT)",
      currency: "USD",
      rate_type: "buy",
      color: "#60BD68",
      dashStyle: "shortdot",
      legendIndex: 4,
      data: [
        [
          1426723200000,
          2.190000057220459
        ],
        [
          1426809600000,
          2.184999942779541
        ],
        [
          1426896000000,
          2.184999942779541
        ]
      ]
    },
    {
      id: "TBCT_USD_S",
      code: "TBCT",
      name: "TBCT Bank (TBCT)",
      currency: "USD",
      rate_type: "sell",
      color: "#60BD68",
      dashStyle: "shortdash",
      legendIndex: 5,
      data: [
        [
          1426723200000,
          2.25
        ],
        [
          1426809600000,
          2.244999885559082
        ],
        [
          1426896000000,
          2.244999885559082
        ]
      ]
    }  
  ]
}</pre>
<p> </p>
')
  

  m = v.api_methods.create(permalink: 'calculator', sort_order: 6, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Depreciation Calculator', content: '<p>Use the Lari Depreciation Calculator to calculate how much your net worth or payment responsibilities have changed over time due to the currency rate change.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/calculator</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently <strong>ka</strong> for Georgian or <strong>en</strong> for English)</li>
</ul>
<h2>Required Parameters</h2>
<p>The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>The code of the currency (e.g., USD)</td>
</tr>
<tr>
<td>amount</td>
<td>The amount of money to calculate the depreciation for</td>
</tr>
<tr>
<td>direction</td>
<td>
<p>Indicates which currency the amount is in and which it should be converted to.</p>
<ul>
<li>0 = Amount is in <strong>Currency </strong>and is to be converted to Lari</li>
<li>1 = Amount is in Lari and is to be converted to <strong>Currency</strong></li>
</ul>
</td>
</tr>
<tr>
<td>start_date</td>
<td>The start date to get exchange rates for, in UTC format (e.g., 1422748800000 is the UTC date for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The end date to get exchange rates for, in UTC format (e.g., 1422748800000 is the UTC date for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<p> </p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters.</p>
<p> </p>
<h2>What You Get</h2>
<p>The return object is a JSON object indicating the start and end rates and the amount gained or lost:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>
<p>Returns two values:</p>
<ul>
<li><strong>from</strong> - the code of the currency that the amount was originally in</li>
<li><strong>to</strong> - the code of the currency that the amount was converted to</li>
</ul>
</td>
</tr>
<tr>
<td>dates</td>
<td>
<p>Returns two values:</p>
<ul>
<li><strong>start</strong> - the start date, in both UTC and normal date format (e.g., 2015-01-01)</li>
<li><strong>end</strong> - the end date, in both UTC and normal date format (e.g., 2015-01-01)</li>
</ul>
</td>
</tr>
<tr>
<td>rates</td>
<td>
<p>Returns two values:</p>
<ul>
<li><strong>start</strong> - the exchange rate at the start date</li>
<li><strong>end</strong> - the exchange rate at the end date</li>
</ul>
</td>
</tr>
<tr>
<td>amount</td>
<td>
<p>Returns four values:</p>
<ul>
<li><strong>original</strong> - the original amount provided by you in the request</li>
<li><strong>start</strong> - the amount at the start date after applying the exchange rate</li>
<li><strong>end</strong> - the amount at the end date after applying the exchange rate</li>
<li><strong>difference</strong> - the end amount minus the start amount; a negative value indicates depreciation</li>
</ul>
</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of computing the depreciation of 1000 USD between 2015-01-01 and 2015-02-01. The URL for this is the following (remember dates must be converted into <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC dates</a>):</p>
<div class="url"><a href="/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1&amp;start_date=1422748800000&amp;end_date=1425168000000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1</a><a href="&amp;start_date=1420070400000&amp;end_date=1422748800000" target="_blank">&amp;start_date=1420070400000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  currency: {
    from: "GEL",
    to: "USD"
  },
  dates: {
    start: {
      utc: 1420070400000,
      date: "2015-01-01"
    },
    end: {
      utc: 1422748800000,
      date: "2015-02-01"
    }
  },
  rates: {
    start: 0.5313213963126295,
    end: 0.4864523033516564
  },
  amounts: {
    original: 1000,
    start: 531.3213963126295,
    end: 486.4523033516564,
    difference: -44.86909296097315
  }
}</pre>
<h3>Example 2</h3>
<p>Here is an example of computing the depreciation of 1000 Lari between 2015-01-01 and 2015-02-01. The URL for this is the following (remember dates must be converted into <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC dates</a>):</p>
<div class="url"><a href="/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=0&amp;start_date=1420070400000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=0&amp;start_date=1420070400000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  currency: {
    from: "USD",
    to: "GEL"
  },
  dates: {
    start: {
      utc: 1420070400000,
      date: "2015-01-01"
    },
    end: {
      utc: 1422748800000,
      date: "2015-02-01"
    }
  },
  rates: {
    start: 1.8821,
    end: 2.0557
  },
  amounts: {
    original: 1000,
    start: 1882.1000000000001,
    end: 2055.7,
    difference: 173.59999999999968
  }
}</pre>
<p> </p>')
  m.api_method_translations.create(locale: 'ka', title: 'გაუფასურების კალკულატორი', content: '<p>გამოიყენეთ ლარის გაუფასურების კალკულატორი რათა დაიანგარიშოთ ვალუტის ცვლილების შედეგად რამდენად შეიცვალა თქვენი შემოსავალი ან გადასახადის ვალდებულებები.</p>
<h2>URL</h2>
<p>ამ მეთოდის გამოძახებისთვის გამოიყენეთ HTTP GET მოთხოვნა შემდეგი URL-სთვის:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/calculator</div>
<p>სად:</p>
<ul class="list-unstyled">
<li>[locale] = ენის ადგილი, რომელშიც გსურთ მონაცემების გადაყვანა (ამ დროისთვის <strong>ka</strong> ქართულად ან <strong>en</strong> ინგლისურად)</li>
</ul>
<h2>აუცილებელი პარამეტრები</h2>
<p>მოთხოვნა უნდა შეიცავდეს შემდეგ პარამეტრებს:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
currency
</td>
<td>
ვალუტის კოდი (მაგ., USD)
</td>
</tr>
<tr>
<td>
amount
</td>
<td>
გაუფასურების გამოსათვლელი თანხის რაოდენობა
</td>
</tr>
<tr>
<td>
direction
</td>
<td>
უთითებს თანხა რომელ ვალუტაშია და რომელში უნდა დაკონვერტირდეს
<ul>
<li>0 = თანხა არის <strong>Currency-ში</strong> და უნდა დაკონვერტირდეს ლარში</li>
<li>1 = თანხა არის ლარში და უნდა დაკონვერტირდეს <strong>Currency-ში</strong></li>
</ul>
</td>
</tr>
<tr>
<td>
start_date
</td>
<td>
გაცვლითი კურსის ინფორმაციის მიღების საწყისი თარიღი, UTC ფორმატში (მაგ., 1422748800000 არის UTC თარიღი 2015-01-01-სთვის) <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC-ს თარიღების შესახებ დამატებითი ინფორმაციის მიღება შესაძლებელია ამ ბმულზე</a>.
</td>
</tr>
<tr>
<td>
end_date
</td>
<td>
გაცვლითი კურსის ინფორმაციის მიღების დასასრული თარიღი, UTC ფორმატში (მაგ., 1422748800000 არის UTC თარიღი 2015-01-01-სთვის) <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC-ს თარიღების შესახებ დამატებითი ინფორმაციის მიღება შესაძლებელია ამ ბმულზე.</a>
</td>
</tr>
</tbody>
</table>
<h2>არჩევითი პარამეტრები</h2>
<p>გამოძახებისთვის არ არის საჭირო არჩევითი &nbsp;პარამეტრები.</p>
<h2>რას მიიღებთ</h2>
<p>დაბრუნებული ობიექტი არის JSON ობიექტი, რომელიც უთითებს თანხის რაოდენობის დასაწყისსა და დასასრულს და მოგებული ან დაკალრგული თანხის რაოდენობას.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>პარამეტრი</th><th>აღწერა</th></tr>
</thead>
<tbody>
<tr>
<td>
currency
</td>
<td>
<p>ორი ღირებულების გადაყვანა:</p>
<ul>
<li><strong>from</strong> - ვალუტის კოდი რომელშიც თანხა თავდაპირველად იყო</li>
<li><strong>to</strong> - ვალუტის კოდი რომელშიც თანხა გადაკონვერტირდა</li>
</ul>
</td>
</tr>
<tr>
<td>
dates
</td>
<td>
<p>ორი ღირებულების გადაყვანა:</p>
<ul>
<li><strong>start</strong> - საწყისი თარიღი, UTC და ჩვეულებრივ ფორმატში (მაგ., 2015-01-01)</li>
<li><strong>end</strong> - ბოლო თარიღი, UTC და ჩვეულებრივ ფორმატში (მაგ., 2015-01-01)</li>
</ul>
</td>
</tr>
<tr>
<td>
rates
</td>
<td>
<p>ორი ღირებულების გადაყვანა:</p>
<ul>
<li><strong>start</strong> - გაცვლითი კურსი საწყისი თარიღის დროს</li>
<li><strong>end</strong> - გაცვლითი კურსი დასასრული თარიღის დროს</li>
</ul>
</td>
</tr>
<tr>
<td>
amount
</td>
<td>
<p>ორი ღირებულების გადაყვანა:</p>
<ul>
<li><strong>original</strong> - თქვენს მიერ მოთხოვნილი პირველადი თანხა</li>
<li><strong>start</strong> - საწყის დღეს არსებული თანხის რაოდენობა, გაცვლითი კურსის მოთხოვნის შემდეგ</li>
<li><strong>end</strong> - ბოლო დღეს არსებული თანხის რაოდენობა, გაცვლითი კურსის მოთხოვნის შემდეგ</li>
<li><strong>difference</strong> - თანხის ბოლო რაოდენობას გამოკლებული საწყისი რაოდენობა; უარყოფითი მაჩვენებელი მიუთითებს გაუფასურებაზე</li>
</ul>
</td>
</tr>
</tbody>
</table>
<h2>მაგალითები</h2>
<h3>მაგალითი 1</h3>
<p>აქ მოცემულია 2015-01-01 - 2015-02-01 პერიოდში 1000 USD-ის გაუფასურების გამოთვლის მაგალითი.მისი URL არის შემდეგი (დაიმახსოვრეთ, თარიღები უნდა იქნას გადაყვანილი <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC ფორმატში</a>):</p>
<div class="url"><a href="/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1&amp;start_date=1422748800000&amp;end_date=1425168000000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1</a><a href="&amp;start_date=1420070400000&amp;end_date=1422748800000" target="_blank">&amp;start_date=1420070400000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  currency: {
    from: "GEL",
    to: "USD"
  },
  dates: {
    start: {
      utc: 1420070400000,
      date: "2015-01-01"
    },
    end: {
      utc: 1422748800000,
      date: "2015-02-01"
    }
  },
  rates: {
    start: 0.5313213963126295,
    end: 0.4864523033516564
  },
  amounts: {
    original: 1000,
    start: 531.3213963126295,
    end: 486.4523033516564,
    difference: -44.86909296097315
  }
}</pre>
<h3>მაგალითი 2</h3>
<p>აქ მოცემულია 2015-01-01 - 2015-02-01 პერიოდში 1000 ლარის გაუფასურების გამოთვლის მაგალითი.მისი URL არის შემდეგი (დაიმახსოვრეთ, თარიღები უნდა იქნას გადაყვანილი <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">UTC ფორმატში</a>):</p>
<div class="url"><a href="/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=0&amp;start_date=1420070400000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=0&amp;start_date=1420070400000&amp;end_date=1422748800000</a></div>
<pre class="brush:js;auto-links:false;toolbar:false" contenteditable="false">{
  valid: true,
  currency: {
    from: "USD",
    to: "GEL"
  },
  dates: {
    start: {
      utc: 1420070400000,
      date: "2015-01-01"
    },
    end: {
      utc: 1422748800000,
      date: "2015-02-01"
    }
  },
  rates: {
    start: 1.8821,
    end: 2.0557
  },
  amounts: {
    original: 1000,
    start: 1882.1000000000001,
    end: 2055.7,
    difference: 173.59999999999968
  }
}</pre>
<p> </p>')
end