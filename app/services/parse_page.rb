class ParsePage
  def self.call(page)
    new(page).parse!
  end

  def initialize(page)
    @page = page
  end

  def parse!
    Nokogiri::HTML::DocumentFragment.parse(@page.content)
  end
end
