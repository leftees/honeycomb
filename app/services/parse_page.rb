class ParsePage
  def self.call(page)
    new(page).parse!
  end

  def initialize(page)
    @page = page
  end

  def parse!
    Nokogiri::HTML(@page.content)
  end
end
