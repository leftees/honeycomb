# Performs batch creation of items from a google doc
# Assumes you have a valid auth token to access the doc
class GoogleCreateItems
  attr_reader :session
  attr_reader :total_count, :valid_count, :new_count, :error_count, :changed_count

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
        errors_array = create!(collection_id: collection_id, items_hash: items) do |item_props|
          RewriteItemMetadata.call(item_hash: item_props)
        end
      end
    end

    {
      summary: {
        total_count: total_count,
        valid_count: valid_count,
        new_count: new_count,
        error_count: error_count,
        changed_count: changed_count
      },
      errors: errors_array
    }
  end

  protected

  # This is written to be fairly generic. If we find that we have a need
  # for other bulk creation mechanisms, ex: our own csv importer, it might
  # be a good idea to pull this out into its own thing and have each specific
  # creation mechanism utilize it
  def create!(collection_id:, items_hash:)
    reset_counts
    ActiveRecord::Base.transaction do
      errors_array = items_hash.map.with_index do |item_props, index|
        item_props = yield(item_props) if block_given?
        item = Item.new(collection_id: collection_id, **item_props)
        CreateUniqueId.call(item)
        update_counts(item: item)
        if item.valid?
          SaveItem.call(item, item_props)
          nil
        else
          { index: index, errors: item.errors.full_messages, item: item }
        end
      end
      errors_array.compact
    end
  end

  def reset_counts
    @total_count = 0
    @valid_count = 0
    @new_count = 0
    @error_count = 0
    @changed_count = 0
  end

  def update_counts(item:)
    if item.valid?
      if item.new_record?
        @new_count += 1
      else
        @changed_count += 1 if item.changed?
      end
      @valid_count += 1
    else
      @error_count += 1
    end
    @total_count += 1
  end
end
