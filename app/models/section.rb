class Section < ActiveRecord::Base
  belongs_to :showcase
  belongs_to :item
  has_one :collection, through: :showcase

  validates :showcase, presence: true

  has_paper_trail

  def slug
    name
  end
end
