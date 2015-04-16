class AddColumnToBank < ActiveRecord::Migration
  def change
    add_column :banks, :order, :integer
  end
end
