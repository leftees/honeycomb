class Section < ActiveRecord::Base
  belongs_to :showcase
  belongs_to :item
  has_one :collection, through: :showcase

  validates :showcase, :unique_id, presence: true

  has_paper_trail

  def slug
    name
  end
end
