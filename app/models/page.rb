class Page < ActiveRecord::Base
  belongs_to :collection

  validates :collection, presence: true

  has_paper_trail
end
