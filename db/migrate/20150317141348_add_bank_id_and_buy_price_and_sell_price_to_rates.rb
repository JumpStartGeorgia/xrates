class AddBankIdAndBuyPriceAndSellPriceToRates < ActiveRecord::Migration
 def up
    add_column :rates, :bank_id, :integer
    add_column :rates, :buy_price, :float
    add_column :rates, :sell_price, :float
  end

  def down
    remove_column :rates, :bank_id
    remove_column :rates, :buy_price
    remove_column :rates, :sell_price
  end
end
