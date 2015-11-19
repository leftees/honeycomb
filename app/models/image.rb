class Image < ActiveRecord::Base
  belongs_to :collection
  has_attached_file :image,
                    restricted_characters: /[&$+,\/:;=?@<>\[\]{}\|\\^~%#]/,
                    styles: {
                      small: "4000x200>",
                      medium: "4000x800>",
                      large: "4000x4000>"
                    },
                    convert_options: {
                      small: "-strip",
                      medium: "-strip",
                      large: "-strip" # should we leave meta here since we are using this as the top level object in the api?
                    }

  validates_attachment_content_type :image, content_type: /\Aimage\/.*\Z/
  validates :collection, presence: true

  has_paper_trail
end
