class CreateApiVersions < ActiveRecord::Migration
  def up
    create_table :api_versions do |t|
      t.string :permalink
      t.boolean :public, default: false
      t.date :public_at

      t.timestamps
    end
    add_index :api_versions, :permalink
    add_index :api_versions, :public
    add_index :api_versions, :public_at

    ApiVersion.create_translation_table! :title => :string
  end
  
  def down
    drop_table :api_versions
    ApiVersion.drop_translation_table!
  end
end
