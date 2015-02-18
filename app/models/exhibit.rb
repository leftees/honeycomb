class Exhibit < ActiveRecord::Base
  has_many :showcases
  belongs_to :collection

  validates :title, presence: true

  def items_json_url
    "/api/collections/#{collection_id}/items.json?include=image"
  end

  def item_json_url(item_id)
    "/api/collections/#{collection_id}/items/#{item_id}.json?include=image"
  end

end
