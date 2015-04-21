class RemovePages < ActiveRecord::Migration
  def up
    drop_table :pages
    drop_table :page_translations
  end

  def down
    # do nothing
  end
end
