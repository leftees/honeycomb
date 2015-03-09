class Collection < ActiveRecord::Base
  has_one :exhibit
  has_many :items
  has_many :collection_users
  has_many :users, :through => :collection_users

  validates :title, :unique_id, presence: true

  has_paper_trail


  def image
    {
                width: "1200 px",
                height: "1600 px",
                contentUrl: "https://placekitten.com/g/1200/1600",
                name: "1200x1600.jpg",
                "thumbnail/medium" => {
                    width: "600 px",
                    height: "800 px",
                    contentUrl: "https://placekitten.com/g/600/800"
                },
                "thumbnail/dzi" => {
                    width: "1200 px",
                    height: "1600 px",
                    contentUrl: "https://honeypotpprd.library.nd.edu/images/honeycomb/000/002/000/056/pyramid/1200x1600.tif.dzi"
                },
                "thumbnail/small" => {
                    width: "150 px",
                    height: "200 px",
                    contentUrl: "https://placekitten.com/g/150/200"
                }
    }
  end
end
