CURRENCIES = Currency.with_translations(:en).map{|x| x.code }
BANKS = Bank.with_translations(:en).map{|x| x.id.to_s }

LAST_SCRAPE = Rate.maximum(:created_at)