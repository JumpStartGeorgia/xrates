class CreateBanks < ActiveRecord::Migration
  def up
    create_table :banks do |t|
      t.string :code
      t.string :buy_color
      t.string :sell_color

      t.timestamps
    end

    Bank.create_translation_table! :name => :string, :image => :string
  end

  def down
    drop_table :banks
    Bank.drop_translation_table!
  end
end