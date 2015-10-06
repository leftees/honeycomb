class Collection < ActiveRecord::Base
  has_one :exhibit
  has_many :items
  has_many :collection_users
  has_many :users, through: :collection_users
  has_many :showcases, through: :exhibit

  validates :name_line_1, :unique_id, presence: true

  has_paper_trail

  def name
    if name_line_2.present?
      "#{name_line_1} #{name_line_2}"
    else
      name_line_1
    end
  end
end
