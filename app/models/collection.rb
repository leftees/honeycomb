class Collection < ActiveRecord::Base
  has_one :exhibit
  has_many :items
  has_many :collection_users
  has_many :users, :through => :collection_users
  has_many :showcases, through: :exhibit

  validates :title, :unique_id, presence: true

  has_paper_trail

end
