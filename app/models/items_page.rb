class ItemsPage < ActiveRecord::Base
  belongs_to :page
  belongs_to :item
end
