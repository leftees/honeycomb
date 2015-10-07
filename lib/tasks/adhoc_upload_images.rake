# Before using this, make sure local_upload is updated to replicate anything new that has been
# added to the items_controller#create code path

namespace :adhoc do
  desc "Warning: This code is not maintained, and will likely only be here temporarily.
        Uploads and creates new items using all images specified in a text file."

  # file_path must point to a text file that has full paths to each file to import, separated
  # by new lines. Ex:
  # $ cat image_paths.txt
  # /Users/jgondron/Documents/1.tif
  # /Users/jgondron/Documents/2.tif
  #
  # Example usage:
  # bundle exec rake adhoc:upload_images[49,"image_paths.txt"]
  task :upload_images, [:collection_id, :file_path] => :environment do |_t, args|
    paths_file = File.new(args[:file_path], "r")
    while (line = paths_file.gets)
      local_upload(collection_id: args[:collection_id], file_path: line.chomp)
    end
    paths_file.close
  end

  def local_upload(collection_id:, file_path:)
    collection = CollectionQuery.new.find(collection_id)
    item = ItemQuery.new(collection.items).build
    file = File.open(file_path)
    save_params = { uploaded_image: file }
    SaveItem.call(item, save_params)
    Index::Item.index!(item)
    file.close
  end
end
