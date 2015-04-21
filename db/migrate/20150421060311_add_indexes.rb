class AddIndexes < ActiveRecord::Migration
  def up
    add_index :banks, :code
    add_index :banks, :order
    add_index :bank_translations, :name

    add_index :currencies, :code
    add_index :currency_translations, :name

    add_index :rates, [:bank_id, :currency, :utc]
    add_index :rates, [:bank_id, :currency, :date]
    remove_index :rates, :name => "index_rates_on_currency_and_date"
    remove_index :rates, :name => "index_rates_on_date_and_currency"
    remove_index :rates, :name => "index_rates_on_utc_and_currency"
  end

  def down
    remove_index :banks, :code
    remove_index :banks, :order
    remove_index :bank_translations, :name

    remove_index :currencies, :code
    remove_index :currency_translations, :name

    remove_index :rates, [:bank_id, :currency, :utc]
    remove_index :rates, [:bank_id, :currency, :date]
    add_index "rates", ["currency", "date"], :name => "index_rates_on_currency_and_date"
    add_index "rates", ["date", "currency"], :name => "index_rates_on_date_and_currency"
    add_index "rates", ["utc", "currency"], :name => "index_rates_on_utc_and_currency"
  end
end
