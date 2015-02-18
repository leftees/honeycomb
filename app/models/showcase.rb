class Showcase < ActiveRecord::Base
  belongs_to :exhibit
  has_many :sections

  has_attached_file :image, :restricted_characters => /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/


  validates :title, :exhibit, presence: true
#  validates :image, attachment_presence: true

end
