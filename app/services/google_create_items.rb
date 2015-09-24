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
    counts = {
      total_count: 0,
      valid_count: 0,
      new_count: 0,
      error_count: 0,
      changed_count: 0
    }
    errors = []

    worksheet = session.get_worksheet(file: file, sheet: sheet)
    if worksheet.present?
      items = session.worksheet_to_hash(worksheet: worksheet)
      create!(collection_id: collection_id, items_hash: items, counts: counts, errors: errors) do |item_props|
        RewriteItemMetadata.call(item_hash: item_props)
      end
    end

    {
      summary: counts,
      errors: errors
    }
  end

  protected

  # This is written to be fairly generic. If we find that we have a need
  # for other bulk creation mechanisms, ex: our own csv importer, it might
  # be a good idea to pull this out into its own thing and have each specific
  # creation mechanism utilize it
  #
  # Attempts to create/update items given ithe items_hash. Increments keys in
  # counts and appends any errors to the given errors array.
  # Count hash keys are defined as:
  #   new_count      - Count of how many new records were created
  #   changed_count  - Count of how many items already existed but were changed
  #   valid_count    - Count of how many items passed validation
  #   error_count    - Count of how many items failed validation
  #   total_count    - Total number of items processed
  def create!(collection_id:, items_hash:, counts:, errors:)
    ActiveRecord::Base.transaction do
      items_hash.each.with_index do |item_props, index|
        item_props = yield(item_props) if block_given?
        item = Item.new(collection_id: collection_id, **item_props)
        CreateUniqueId.call(item)
        update_counts(item: item, counts: counts)
        unless item.valid? && SaveItem.call(item, {})
          errors << { index: index, errors: item.errors.full_messages, item: item }
        end
      end
    end
  end

  def update_counts(item:, counts:)
    if item.valid?
      if item.new_record?
        counts[:new_count] += 1
      else
        counts[:changed_count] += 1 if item.changed?
      end
      counts[:valid_count] += 1
    else
      counts[:error_count] += 1
    end
    counts[:total_count] += 1
  end
end
