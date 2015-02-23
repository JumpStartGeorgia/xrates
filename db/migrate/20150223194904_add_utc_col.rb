class AddUtcCol < ActiveRecord::Migration
  def up
    add_column :rates, :utc, :datetime
    add_index :rates, [:utc, :currency]

    puts "#######################################"
    puts "empty your rates table and rerun the populate rake task to reload"
    puts "it is much quicker this way!"
    puts "#######################################"
  end

  def down
    remove_index :rates, [:utc, :currency]
    remove_column :rates, :utc
  end
end
