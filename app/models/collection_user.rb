class CollectionUser < ActiveRecord::Base
  belongs_to :collection
  belongs_to :user

  has_paper_trail
end
