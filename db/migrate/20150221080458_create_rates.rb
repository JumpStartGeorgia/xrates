class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.date :date
      t.string :currency
      t.float :rate

      t.timestamps
    end

    add_index :rates, [:date, :currency]
    add_index :rates, [:currency, :date]
  end
end
