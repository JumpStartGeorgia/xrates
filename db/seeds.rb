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
  <h2>The URL to the api is the following:</h2>
  <div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/[version]/</div>
  <p>where:</p>
  <ul class="list-unstyled">
  <li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
  <li>[version] = the version number of the api (see below)</li>
  </ul>
  <h2>API Calls</h2>
  <p>The following is a list of calls that are available in each version of the api.</p>')
  p.page_content_translations.create(:locale => 'ka', :title => 'API', :content => '<p>The Lari Explorer API allows you to obtain information about the National Bank of Georgia’s currency rates, buy and sell rates of commercial banks operating in Georgia and other related information, as seen on the Lari Explorer website.</p>
  <h2>The URL to the api is the following:</h2>
  <div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/[version]/</div>
  <p>where:</p>
  <ul class="list-unstyled">
  <li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
  <li>[version] = the version number of the api (see below)</li>
  </ul>
  <h2>API Calls</h2>
  <p>The following is a list of calls that are available in each version of the api.</p>')
end

#####################
## Create API Versions/Methods
#####################
puts 'Creating API Versions/Methods'
v = ApiVersion.by_permalink('v1')
if v.blank?
  v = ApiVersion.create(permalink: 'v1')
  v.api_version_translations.create(locale: 'en', title: 'Version 1')
  v.api_version_translations.create(locale: 'ka', title: 'Version 1')
end
if v.present? && v.api_methods.empty?
  m = v.api_methods.create(permalink: 'nbg', sort_order: 1)
  m.api_method_translations.create(locale: 'en', title: 'National Bank of Georgia Rate', content: '<p>Get Lari&nbsp;exchange rates&nbsp;for a currency, or currencies, from&nbsp;the National Bank of Georgia.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/nbg</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Require Parameters</h2>
<p>&nbsp;The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>&nbsp;currency</td>
<td>A currency code to get exchange rates for. Can provide one currency code (e.g., USD for U.S. Dollars) or a comma separated list (e.g., USD,EUR,GBP).</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<h2>Optional Parameters</h2>
<p>There following&nbsp;parameters are optional and can be used to help limit the data that is desired. At this time, both the start_date and end_date must be provided in order for the date filters to be applied. If no dates are provided, all exchange rates on file will be returned.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>&nbsp;start_date</td>
<td>The date to start getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop&nbsp;getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<h2>What You Get</h2>
<p>&nbsp;The return object is a JSON array of currencies and their exchange rates&nbsp;with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>code</td>
<td>Currency code</td>
</tr>
<tr>
<td>name</td>
<td>The name of the currency</td>
</tr>
<tr>
<td>ratio</td>
<td>The&nbsp;number of this currency to 1 Lari</td>
</tr>
<tr>
<td>rates</td>
<td>An array of exchange rates between the requested dates, or all rates on file if no dates are provided</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is a simple example of getting all exchange rates on file for the U.S. Dollar. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/nbg?currency=USD</div>
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
<p>Here is an example of getting all exchange rates on file for the U.S. Dollar and Pound Sterling. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/nbg?currency=USD,GBP</div>
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
}</pre>')
  m.api_method_translations.create(locale: 'ka', title: 'National Bank of Georgia Rate', content: '<p>Get Lari&nbsp;exchange rates&nbsp;for a currency, or currencies, from&nbsp;the National Bank of Georgia.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/nbg</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Require Parameters</h2>
<p>&nbsp;The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>&nbsp;currency</td>
<td>A currency code to get exchange rates for. Can provide one currency code (e.g., USD for U.S. Dollars) or a comma separated list (e.g., USD,EUR,GBP).</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<h2>Optional Parameters</h2>
<p>There following&nbsp;parameters are optional and can be used to help limit the data that is desired. At this time, both the start_date and end_date must be provided in order for the date filters to be applied. If no dates are provided, all exchange rates on file will be returned.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>&nbsp;start_date</td>
<td>The date to start getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop&nbsp;getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<h2>What You Get</h2>
<p>&nbsp;The return object is a JSON array of currencies and their exchange rates&nbsp;with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>code</td>
<td>Currency code</td>
</tr>
<tr>
<td>name</td>
<td>The name of the currency</td>
</tr>
<tr>
<td>ratio</td>
<td>The&nbsp;number of this currency to 1 Lari</td>
</tr>
<tr>
<td>rates</td>
<td>An array of exchange rates between the requested dates, or all rates on file if no dates are provided</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is a simple example of getting all exchange rates on file for the U.S. Dollar. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/nbg?currency=USD</div>
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
<p>Here is an example of getting all exchange rates on file for the U.S. Dollar and Pound Sterling. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/nbg?currency=USD,GBP</div>
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
}</pre>')

  m = v.api_methods.create(permalink: 'rates', sort_order: 2)
  m.api_method_translations.create(locale: 'en', title: 'Commerical Bank Rates', content: '<p>Get commercial bank buy and sell exchange rates for a&nbsp;currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/rates</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Require Parameters</h2>
<p>&nbsp;The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>Code of currency&nbsp;(e.g., USD for U.S. Dollars).</td>
</tr>
<tr>
<td>bank</td>
<td>Code of bank&nbsp;to get exchange rates from. Can provide one bank&nbsp;code (e.g., BAGA for Bank of Georgia) or a comma separated list (e.g., BAGA,TBCB)</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<h2>Optional Parameters</h2>
<p>There following&nbsp;parameters are optional and can be used to help limit the data that is desired. At this time, both the start_date and end_date must be provided in order for the date filters to be applied. If no dates are provided, all exchange rates on file will be returned.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>&nbsp;start_date</td>
<td>The date to start getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop&nbsp;getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<h2>What You Get</h2>
<p>&nbsp;The return object is a JSON array of currencies and their exchange rates&nbsp;with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>id</td>
<td>A combination of the bank and currency code</td>
</tr>
<tr>
<td>name</td>
<td>The name of the&nbsp;bank</td>
</tr>
<tr>
<td>data</td>
<td>An array of&nbsp;exchange rates between the requested dates, or all rates on file if no dates are provided</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is a simple example of getting the&nbsp;buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/nbg?currency=USD&amp;bank=BAGA</div>')
  m.api_method_translations.create(locale: 'ka', title: 'Commerical Bank Rates', content: '<p>Get commercial bank buy and sell exchange rates for a&nbsp;currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/rates</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Require Parameters</h2>
<p>&nbsp;The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>Code of currency&nbsp;(e.g., USD for U.S. Dollars).</td>
</tr>
<tr>
<td>bank</td>
<td>Code of bank&nbsp;to get exchange rates from. Can provide one bank&nbsp;code (e.g., BAGA for Bank of Georgia) or a comma separated list (e.g., BAGA,TBCB)</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<h2>Optional Parameters</h2>
<p>There following&nbsp;parameters are optional and can be used to help limit the data that is desired. At this time, both the start_date and end_date must be provided in order for the date filters to be applied. If no dates are provided, all exchange rates on file will be returned.</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>&nbsp;start_date</td>
<td>The date to start getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop&nbsp;getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<h2>What You Get</h2>
<p>&nbsp;The return object is a JSON array of currencies and their exchange rates&nbsp;with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>id</td>
<td>A combination of the bank and currency code</td>
</tr>
<tr>
<td>name</td>
<td>The name of the&nbsp;bank</td>
</tr>
<tr>
<td>data</td>
<td>An array of&nbsp;exchange rates between the requested dates, or all rates on file if no dates are provided</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is a simple example of getting the&nbsp;buy and sell exchange rates on file for the U.S. Dollar at the Bank of Georgia. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/nbg?currency=USD&amp;bank=BAGA</div>')
  
  m = v.api_methods.create(permalink: 'calculator', sort_order: 3)
  m.api_method_translations.create(locale: 'en', title: 'Depreciation Calculator', content: '<p>Get commercial bank buy and sell exchange rates for a&nbsp;currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/calculator</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Require Parameters</h2>
<p>&nbsp;The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>Code of currency&nbsp;(e.g., USD for U.S. Dollars).</td>
</tr>
<tr>
<td>amount</td>
<td>The amount of money to calculate the depreciation</td>
</tr>
<tr>
<td>direction</td>
<td>
<p>Indicates&nbsp;which currency the amount is in and which it should be converted to.&nbsp;</p>
<ul>
<li>0 = Amount&nbsp;is in <strong>Currency </strong>and is to be converted to Lari</li>
<li>1 = Amount is in Lari and is to be converted to <strong>Currency</strong></li>
</ul>
</td>
</tr>
<tr>
<td>start_date</td>
<td>The date to start getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop&nbsp;getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters.</p>
<p>&nbsp;</p>
<h2>What You Get</h2>
<p>&nbsp;The return object is a JSON array of currencies and their exchange rates&nbsp;with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>amount</td>
<td>The&nbsp;original amount provided by you in the request</td>
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
<td>&nbsp;date_start</td>
<td>&nbsp;The start date</td>
</tr>
<tr>
<td>rate_start</td>
<td>&nbsp;The exchange rate at the start date</td>
</tr>
<tr>
<td>amount_start</td>
<td>The amount at the start date&nbsp;</td>
</tr>
<tr>
<td>date_end</td>
<td>The end date&nbsp;</td>
</tr>
<tr>
<td>rate_end</td>
<td>The exchange rate at the end date&nbsp;</td>
</tr>
<tr>
<td>amount_end</td>
<td>The amount at the end date&nbsp;</td>
</tr>
<tr>
<td>amount_diff</td>
<td>The difference between the start and end amounts&nbsp;</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an&nbsp;example of computing the depreciation of $1000 between 2015-01-01 and 2015-02-01. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1&amp;date_start=1422748800000&amp;date_end=1425168000000</div>')
  m.api_method_translations.create(locale: 'ka', title: 'Depreciation Calculator', content: '<p>Get commercial bank buy and sell exchange rates for a&nbsp;currency. For comparison, the National Bank of Georgia suggested exchange rate for the currency will also be returned.</p>
<h2>URL</h2>
<p>To call this method, use an HTTP GET request to the following URL:</p>
<div class="url">http://dev-xrates.jumpstart.ge/[locale]/api/v1/calculator</div>
<p>where:</p>
<ul class="list-unstyled">
<li>[locale] = the locale of the language you want the data to be returned in (currently ka for Georgian or en for English)</li>
</ul>
<h2>Require Parameters</h2>
<p>&nbsp;The following parameters must be included in the request:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>currency</td>
<td>Code of currency&nbsp;(e.g., USD for U.S. Dollars).</td>
</tr>
<tr>
<td>amount</td>
<td>The amount of money to calculate the depreciation</td>
</tr>
<tr>
<td>direction</td>
<td>
<p>Indicates&nbsp;which currency the amount is in and which it should be converted to.&nbsp;</p>
<ul>
<li>0 = Amount&nbsp;is in <strong>Currency </strong>and is to be converted to Lari</li>
<li>1 = Amount is in Lari and is to be converted to <strong>Currency</strong></li>
</ul>
</td>
</tr>
<tr>
<td>start_date</td>
<td>The date to start getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
<tr>
<td>end_date</td>
<td>The date to stop&nbsp;getting exchange rates for,&nbsp;in UTC format (e.g., 1422748800000 is the UTC date&nbsp;for 2015-01-01). <a href="http://www.w3schools.com/jsref/jsref_utc.asp" target="_blank">Go&nbsp;here for more information about UTC dates</a>.</td>
</tr>
</tbody>
</table>
<p>&nbsp;</p>
<h2>Optional Parameters</h2>
<p>There are no optional parameters.</p>
<p>&nbsp;</p>
<h2>What You Get</h2>
<p>&nbsp;The return object is a JSON array of currencies and their exchange rates&nbsp;with the following information:</p>
<table class="table table-bordered table-hover table-nonfluid">
<thead>
<tr><th>Parameter</th><th>Description</th></tr>
</thead>
<tbody>
<tr>
<td>amount</td>
<td>The&nbsp;original amount provided by you in the request</td>
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
<td>&nbsp;date_start</td>
<td>&nbsp;The start date</td>
</tr>
<tr>
<td>rate_start</td>
<td>&nbsp;The exchange rate at the start date</td>
</tr>
<tr>
<td>amount_start</td>
<td>The amount at the start date&nbsp;</td>
</tr>
<tr>
<td>date_end</td>
<td>The end date&nbsp;</td>
</tr>
<tr>
<td>rate_end</td>
<td>The exchange rate at the end date&nbsp;</td>
</tr>
<tr>
<td>amount_end</td>
<td>The amount at the end date&nbsp;</td>
</tr>
<tr>
<td>amount_diff</td>
<td>The difference between the start and end amounts&nbsp;</td>
</tr>
</tbody>
</table>
<h2>Examples</h2>
<h3>Example 1</h3>
<p>Here is an&nbsp;example of computing the depreciation of $1000 between 2015-01-01 and 2015-02-01. The URL for this is the following:</p>
<div class="url">http://dev-xrates.jumpstart.ge/en/api/v1/calculator?currency=USD&amp;amount=1000&amp;direction=1&amp;date_start=1422748800000&amp;date_end=1425168000000</div>')
end