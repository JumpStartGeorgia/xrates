class CreateRates < ActiveRecord::Migration
  def change
    create_table :rates do |t|
      t.datetime :date
      t.string :currency
      t.float :rate

      t.timestamps
    end
  end
end
