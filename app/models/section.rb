class Section < ActiveRecord::Base
  belongs_to :showcase

  validates :showcase, presence: true

  def updated_at
    Time.now
  end
end
