class Section < ActiveRecord::Base
  belongs_to :showcase

  validates :showcase, presence: true

end
