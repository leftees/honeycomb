class CopyCollectionIdToShowcase < ActiveRecord::Migration
  def up
    case ActiveRecord::Base.connection.class.name
    when /.*Mysql.*/
      execute "UPDATE showcases INNER JOIN exhibits ON exhibits.id = showcases.exhibit_id
               SET showcases.collection_id = exhibits.collection_id;"
    else
      execute "UPDATE showcases SET collection_id = exhibits.collection_id FROM exhibits WHERE exhibits.id = showcases.exhibit_id;"
    end
  end

  def down
  end
end
