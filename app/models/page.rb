class Page < ActiveRecord::Base
  belongs_to :collection

  validates :name, presence: true
  validates :collection, presence: true

  has_paper_trail

  def slug
    name
  end
end
