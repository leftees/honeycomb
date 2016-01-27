class Page < ActiveRecord::Base
  belongs_to :collection
  belongs_to :image
  has_many :items_pages
  has_many :items, through: :items_pages

  validates :name, presence: true
  validates :collection, presence: true

  has_paper_trail

  def slug
    name
  end
end
