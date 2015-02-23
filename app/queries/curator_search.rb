class CuratorSearch

  def self.search(string, collection_id: nil)
    results = api_search(string)
    if !results.blank?
      results
    else
      nil
    end
  end

  private

  def self.api_search(string)
    HesburghAPI::PersonSearch.search(URI::encode(string) + '*')
  end

end
