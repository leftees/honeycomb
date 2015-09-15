# Performs batch creation of items from a google doc
# Assumes you have a valid auth token to access the doc
class GoogleCreateItems
  attr_reader :session

  # Simplified call to create_from_worksheet!
  def self.call(auth_code:, callback_uri:, collection_id:, file:, sheet:)
    instance = new(auth_code: auth_code, callback_uri: callback_uri)
    instance.create_from_worksheet!(collection_id: collection_id, file: file, sheet: sheet)
  end

  def initialize(auth_code:, callback_uri:)
    @session = GoogleSession.new
    session.connect(auth_code: auth_code, callback_uri: callback_uri)
  end

  # Adds new items to a collection for each row in a google spread sheet
  def create_from_worksheet!(collection_id:, file:, sheet:)
    worksheet = session.get_worksheet(file: file, sheet: sheet)
    unless worksheet.nil?
      items = session.worksheet_to_hash(worksheet: worksheet)
      unless items.nil?
        create!(items_hash: items) do |item_props|
          item_props[:collection_id] = collection_id
          RewriteItemMetadata.call(item_hash: item_props)
        end
      end
    end
  end

  protected

  # This is written to be fairly generic. If we find that we have a need
  # for other bulk creation mechanisms, ex: our own csv importer, it might
  # be a good idea to pull this out into its own thing and have each specific
  # creation mechanism utilize it
  def create!(items_hash:)
    ActiveRecord::Base.transaction do
      items_hash.each do |item_props|
        item_props = yield(item_props) if block_given?
        item = Item.new(item_props)
        unless SaveItem.call(item, item_props)
          # Dumb way to handle presenting invalid records for now
          raise "#{item.errors.messages}\n#{item.inspect}"
        end
      end
    end
  end
end
