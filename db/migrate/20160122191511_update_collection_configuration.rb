class UpdateCollectionConfiguration < ActiveRecord::Migration
  def change
    Collection.all.each do |collection|
      CreateCollectionConfiguration.call(collection)
    end
  end
end
