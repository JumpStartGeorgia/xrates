# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# #####################
# ## Pages
# #####################
# puts "Loading Pages"
# Page.delete_all
# PageTranslation.delete_all
# p = Page.create(:id => 1, :name => 'about')
# p.page_translations.create(:locale => 'en', :title => 'About Bootstrap Starter Project', :content => 'You have run rake db:seed and this is an example of translated content. Click the Language Switcher link in the top-right corner to view the text in another language.')
# p.page_translations.create(:locale => 'ka', :title => "'Bootstrap Starter' პროექტის შესახებ", :content => "თქვენ ჩაუშვით 'rake db:seed' და ეს არის კონტენტის თარგმანის მაგალით. ტექსტის სხვა ენაზე სანახავად დააჭირეთ ენის გადამრთველის ბმულს მარჯვენა ზედა კუთხეში.")


#####################
## Currencies
#####################
puts "Loading Currenices"
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


#####################
## Banks
#####################
puts "Loading Banks"
bankInfo = CSV.open("#{Rails.root}/datafiles/info/banks.csv", headers: false).read
created_at = Time.now
ActiveRecord::Base.connection.execute("truncate table banks")
ActiveRecord::Base.connection.execute("truncate table bank_translations")
sql = "insert into banks (code, buy_color, sell_color, created_at, updated_at, order) values "
sql1 = "insert into bank_translations (bank_id, locale, name, image, created_at, updated_at, order) values "
bankInfo.each_with_index do |t,i|
  sql << "(\"#{t[0]}\", \"#{t[5]}\", \"#{t[6]}\", \"#{created_at}\", \"#{created_at}\", \"#{t[7]}\"),"
  sql1 << "(\"#{i+1}\", \"en\", \"#{t[1]}\", \"#{t[3] + (t[4]=='1' ? '' : '_en' )}\", \"#{created_at}\", \"#{created_at}\"),"
  sql1 << "(\"#{i+1}\", \"ka\", \"#{t[2]}\", \"#{t[3] + (t[4]=='1' ? '' : '_ge' )}\", \"#{created_at}\", \"#{created_at}\"),"
end
sql[sql.length-1] = ''
sql1[sql1.length-1] = ''
ActiveRecord::Base.connection.execute(sql)
ActiveRecord::Base.connection.execute(sql1)

