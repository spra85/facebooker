ActiveAdmin.register FacebookPost do
  filter :post_id
  filter :impressions
  filter :clicks
  filter :name
  filter :post_time
  filter :facebook_page

  csv do
    column :post_id
    column :name
    column :post_time
    column :impressions
    column :clicks
    column :message
  end

  index do
    column :post_id
    column :name
    column :impressions
    column :clicks
    column :post_time
    column :message
    actions
  end
end
