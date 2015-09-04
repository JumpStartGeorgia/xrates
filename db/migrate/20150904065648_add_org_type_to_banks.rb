class AddOrgTypeToBanks < ActiveRecord::Migration
  def change
    add_column :banks, :org_type, :integer
  end
end
