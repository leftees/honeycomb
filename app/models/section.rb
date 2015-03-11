class Section < ActiveRecord::Base
  belongs_to :showcase
  belongs_to :item

  validates :showcase, presence: true

  def updated_at
    Time.now
  end
end
