# Performs batch export of items to a google doc
# Assumes you have a valid auth token to access the doc
class GoogleExportItems
  attr_reader :session

  # Simplified call to create_from_worksheet!
  def self.call(auth_code:, callback_uri:, items:, file:, sheet:)
    instance = new(auth_code: auth_code, callback_uri: callback_uri)
    instance.export_to_worksheet!(items: items, file: file, sheet: sheet)
  end

  def initialize(auth_code:, callback_uri:)
    @session = GoogleSession.new
    session.connect(auth_code: auth_code, callback_uri: callback_uri)
  end

  def export_to_worksheet!(items:, file:, sheet:)
    worksheet = session.get_worksheet(file: file, sheet: sheet)
    if worksheet.present?
      item_hashes = items.map do |item|
        RewriteItemMetadataForExport.call(user_defined_id: item.user_defined_id, item_hash: item.metadata, configuration: configuration(item.collection))
      end
      session.hashes_to_worksheet(worksheet: worksheet, hashes: item_hashes)
    end
  end

  private

  def configuration(collection)
    @configuration ||= CollectionConfigurationQuery.new(collection).find
  end
end
