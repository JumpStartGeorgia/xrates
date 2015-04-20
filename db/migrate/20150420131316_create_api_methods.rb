class CreateApiMethods < ActiveRecord::Migration
  def up
    create_table :api_methods do |t|
      t.integer :api_version_id
      t.string :permalink
      t.integer :sort_order, default: 1
      t.boolean :public, default: false
      t.date :public_at

      t.timestamps
    end
    add_index :api_methods, [:api_version_id, :permalink]
    add_index :api_methods, :sort_order
    add_index :api_methods, :public
    add_index :api_methods, :public_at

    ApiMethod.create_translation_table! :title => :string, :content => :text
  end
  
  def down
    drop_table :api_methods
    ApiMethod.drop_translation_table!
  end

end
