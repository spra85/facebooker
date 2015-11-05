class CreateFacebookPosts < ActiveRecord::Migration
  def change
    create_table :facebook_posts do |t|
      t.belongs_to :facebook_page
      t.string :post_id, null: false
      t.string :name
      t.text :message
      t.integer :impressions
      t.integer :clicks
      t.timestamp :post_time
      t.timestamps
    end
  end
end
