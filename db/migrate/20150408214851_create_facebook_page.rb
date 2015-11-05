class CreateFacebookPage < ActiveRecord::Migration
  def change
    create_table :facebook_pages do |t|
      t.string :name
      t.string :page_id, null: false
      t.timestamps
    end
  end
end
