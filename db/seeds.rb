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
  m.api_method_translations.create(locale: 'en', title: 'National Bank of Georgia Rate', content: 'coming soon ...')
  m.api_method_translations.create(locale: 'ka', title: 'National Bank of Georgia Rate', content: 'coming soon ...')

  m = v.api_methods.create(permalink: 'rates', sort_order: 2)
  m.api_method_translations.create(locale: 'en', title: 'Commerical Bank Rates', content: 'coming soon ...')
  m.api_method_translations.create(locale: 'ka', title: 'Commerical Bank Rates', content: 'coming soon ...')
  
  m = v.api_methods.create(permalink: 'calculator', sort_order: 3)
  m.api_method_translations.create(locale: 'en', title: 'Depreciation Calculator', content: 'coming soon ...')
  m.api_method_translations.create(locale: 'ka', title: 'Depreciation Calculator', content: 'coming soon ...')
end