class AddMissingUpdateIndex < ActiveRecord::Migration
  def up
    add_index :rates, :updated_at
  end

  def down
    remove_index :rates, :updated_at
  end
end
