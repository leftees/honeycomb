class Section < ActiveRecord::Base
  belongs_to :showcase
  belongs_to :item
  has_one :collection, through: :showcase

  validates :showcase, presence: true

  def updated_at
    Time.now
  end
end
