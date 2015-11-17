class Image < ActiveRecord::Base
  belongs_to :collection
  has_attached_file :image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/,
                    styles: {
                      small: "x200>",
                      medium: "x800>",
                      dzi: "4000x4000>"
                    }
  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :collection, presence: true

  has_paper_trail
end
