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
  sql << "(\"#{t[0]}\", \"#{t[5]}\", \"#{t[6]}\", \"#{created_at}\", \"#{created_at}\", \"#{t[7]}\"),"
  sql_trans << "(\"#{i+1}\", \"en\", \"#{t[1]}\", \"#{t[3] + (t[4]=='1' ? '' : '_en' )}\", \"#{created_at}\", \"#{created_at}\"),"
  sql_trans << "(\"#{i+1}\", \"ka\", \"#{t[2]}\", \"#{t[3] + (t[4]=='1' ? '' : '_ge' )}\", \"#{created_at}\", \"#{created_at}\"),"
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
  p.page_content_translations.create(:locale => 'en', :title => 'About', :content => 'Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.')
  p.page_content_translations.create(:locale => 'ka', :title => "'About", :content => "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat. Duis autem vel eum iriure dolor in hendrerit in vulputate velit esse molestie consequat, vel illum dolore eu feugiat nulla facilisis at vero eros et accumsan et iusto odio dignissim qui blandit praesent luptatum zzril delenit augue duis dolore te feugait nulla facilisi. Nam liber tempor cum soluta nobis eleifend option congue nihil imperdiet doming id quod mazim placerat facer possim assum. Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat. Ut wisi enim ad minim veniam, quis nostrud exerci tation ullamcorper suscipit lobortis nisl ut aliquip ex ea commodo consequat.")
end
if PageContent.where(id: 2).blank?
  p = PageContent.create(:id => 2, :name => 'api')
  p.page_content_translations.create(:locale => 'en', :title => 'API', :content => '<p>The Lari Explorer API allows you to obtain information about the National Bank of Georgia’s currency rates, buy and sell rates of commercial banks operating in Georgia and other related information, as seen on the Lari Explorer website.</p>
  <h2>The URL to the API is the following:</h2>
  <div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/[version]/</div>
  <p>where:</p>
  <ul class="list-unstyled">
  <li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
  <li>[version] = the version number of the API (see below)</li>
  </ul>
  <h2>API Calls</h2>
  <p>The following is a list of calls that are available in each version of the API.</p>')
  p.page_content_translations.create(:locale => 'ka', :title => 'API', :content => '<p>The Lari Explorer API allows you to obtain information about the National Bank of Georgia’s currency rates, buy and sell rates of commercial banks operating in Georgia and other related information, as seen on the Lari Explorer website.</p>
  <h2>The URL to the API is the following:</h2>
  <div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/[version]/</div>
  <p>where:</p>
  <ul class="list-unstyled">
  <li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
  <li>[version] = the version number of the API (see below)</li>
  </ul>
  <h2>API Calls</h2>
  <p>The following is a list of calls that are available in each version of the API.</p>')
end

#####################
## Create API Versions/Methods
#####################
puts 'Creating API Versions/Methods'
v = ApiVersion.by_permalink('v1')
if v.blank?
  v = ApiVersion.create(permalink: 'v1', public: true)
  v.api_version_translations.create(locale: 'en', title: 'Version 1')
  v.api_version_translations.create(locale: 'ka', title: 'Version 1')
end
if v.present? && v.api_methods.empty?
  m = v.api_methods.create(permalink: 'nbg_currencies', sort_order: 1, public: true)
  m.api_method_translations.create(locale: 'en', title: 'National Bank of Georgia Currencies', content: '')
  m.api_method_translations.create(locale: 'ka', title: 'National Bank of Georgia Currencies', content: '')

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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD</a></div>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD,GBP" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD,GBP</a></div>
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

  m.api_method_translations.create(locale: 'ka', title: 'National Bank of Georgia Rates', content: '<p>Get Lari exchange rates from the National Bank of Georgia for one or more currencies.</p>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD</a></div>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD,GBP" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/nbg_rates?currency=USD,GBP</a></div>
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


  m = v.api_methods.create(permalink: 'commercial_banks', sort_order: 3, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Commerical Banks', content: '')
  m.api_method_translations.create(locale: 'ka', title: 'Commerical Banks', content: '')

  m = v.api_methods.create(permalink: 'commercial_banks_with_currency', sort_order: 4, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Commerical Banks with Currency', content: '')
  m.api_method_translations.create(locale: 'ka', title: 'Commerical Banks with Currency', content: '')


  m = v.api_methods.create(permalink: 'commercial_bank_rates', sort_order: 5, public: true)
  m.api_method_translations.create(locale: 'en', title: 'Commerical Bank Rates', content: '<p>Get commercial bank\'s buy and sell exchange rates for a currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
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
<td>The code of the bank to get exchange rates from. Can provide one bank code (e.g., BAGA) or a comma separated list (e.g., BAGA,TBCB)</td>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA</a></div>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
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
<p>Here is an example of getting the buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia and TBC Bank. The URL for this is the following:</p>
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCB" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCB</a></div>
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
      id: "TBCB_USD_B",
      code: "TBCB",
      name: "TBC Bank (TBCB)",
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
      id: "TBCB_USD_S",
      code: "TBCB",
      name: "TBC Bank (TBCB)",
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
  m.api_method_translations.create(locale: 'ka', title: 'Commerical Bank Rates', content: '<p>Get commercial bank\'s buy and sell exchange rates for a currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
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
<td>The code of the bank to get exchange rates from. Can provide one bank code (e.g., BAGA) or a comma separated list (e.g., BAGA,TBCB)</td>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA</a></div>
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
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA&amp;start_date=1391212800000&amp;end_date=1422748800000</a></div>
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
<p>Here is an example of getting the buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia and TBC Bank. The URL for this is the following:</p>
<div class="url"><a href="http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCB" target="_blank">http://dev-xrates.jumpstart.ge/en/api/v1/commercial_bank_rates?currency=USD&amp;bank=BAGA,TBCB</a></div>
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
      id: "TBCB_USD_B",
      code: "TBCB",
      name: "TBC Bank (TBCB)",
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
      id: "TBCB_USD_S",
      code: "TBCB",
      name: "TBC Bank (TBCB)",
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
  m.api_method_translations.create(locale: 'en', title: 'Depreciation Calculator', content: '<p>Get commercial bank buy and sell exchange rates for a currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/calculator</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Required Parameters</h2>
<p> The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>Code of currency (e.g., USD for U.S. Dollars).</td>
</tr>
<tr>
<td>amount</td>
<td>The amount of money to calculate the depreciation</td>
</tr>
<tr>
<td>direction</td>
<td>
<p>Indicates which currency the amount is in and which it should be converted to. </p>
<ul>
<li>0 = Amount is in <strong>Currency </strong>and is to be converted to Lari</li>
<li>1 = Amount is in Lari and is to be converted to <strong>Currency</strong></li>
</ul>
</td>
</tr>
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
<p> </p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters.</p>
<p> </p>
<h2>What You Get</h2>
<p> The return object is a JSON array of currencies and their exchange rates with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>amount</td>
<td>The original amount provided by you in the request</td>
</tr>
<tr>
<td>currency_from</td>
<td>Currency code that the amount was originally in</td>
</tr>
<tr>
<td>currency_to</td>
<td>Currency code that the amount was converted to</td>
</tr>
<tr>
<td> date_start</td>
<td> The start date</td>
</tr>
<tr>
<td>rate_start</td>
<td> The exchange rate at the start date</td>
</tr>
<tr>
<td>amount_start</td>
<td>The amount at the start date </td>
</tr>
<tr>
<td>date_end</td>
<td>The end date </td>
</tr>
<tr>
<td>rate_end</td>
<td>The exchange rate at the end date </td>
</tr>
<tr>
<td>amount_end</td>
<td>The amount at the end date </td>
</tr>
<tr>
<td>amount_diff</td>
<td>The difference between the start and end amounts </td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of computing the depreciation of $1000 between 2015-01-01 and 2015-02-01. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1&amp;date_start=1422748800000&amp;date_end=1425168000000</div>')
  m.api_method_translations.create(locale: 'ka', title: 'Depreciation Calculator', content: '<p>Get commercial bank buy and sell exchange rates for a currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/calculator</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Required Parameters</h2>
<p> The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>Code of currency (e.g., USD for U.S. Dollars).</td>
</tr>
<tr>
<td>amount</td>
<td>The amount of money to calculate the depreciation</td>
</tr>
<tr>
<td>direction</td>
<td>
<p>Indicates which currency the amount is in and which it should be converted to. </p>
<ul>
<li>0 = Amount is in <strong>Currency </strong>and is to be converted to Lari</li>
<li>1 = Amount is in Lari and is to be converted to <strong>Currency</strong></li>
</ul>
</td>
</tr>
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
<p> </p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters.</p>
<p> </p>
<h2>What You Get</h2>
<p> The return object is a JSON array of currencies and their exchange rates with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>amount</td>
<td>The original amount provided by you in the request</td>
</tr>
<tr>
<td>currency_from</td>
<td>Currency code that the amount was originally in</td>
</tr>
<tr>
<td>currency_to</td>
<td>Currency code that the amount was converted to</td>
</tr>
<tr>
<td> date_start</td>
<td> The start date</td>
</tr>
<tr>
<td>rate_start</td>
<td> The exchange rate at the start date</td>
</tr>
<tr>
<td>amount_start</td>
<td>The amount at the start date </td>
</tr>
<tr>
<td>date_end</td>
<td>The end date </td>
</tr>
<tr>
<td>rate_end</td>
<td>The exchange rate at the end date </td>
</tr>
<tr>
<td>amount_end</td>
<td>The amount at the end date </td>
</tr>
<tr>
<td>amount_diff</td>
<td>The difference between the start and end amounts </td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an example of computing the depreciation of $1000 between 2015-01-01 and 2015-02-01. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1&amp;date_start=1422748800000&amp;date_end=1425168000000</div>')
end