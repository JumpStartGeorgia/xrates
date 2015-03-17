class CreateCurrencies < ActiveRecord::Migration
  def up
    create_table :currencies do |t|
      t.string :code
      t.integer :ratio

      t.timestamps
    end

    Currency.create_translation_table! :name => :string
  end

  def down
    drop_table :currencies
    Currency.drop_translation_table!
  end
end