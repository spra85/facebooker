class FacebookPost < ActiveRecord::Base
  belongs_to :facebook_page

  validates :post_id, uniqueness: true
end
