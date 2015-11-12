class SavePage
  attr_reader :page, :params

  def self.call(page, params)
    new(page, params).save
  end

  def initialize(page, params)
    @page = page
    @params = params
  end

  def save
    page.attributes = params

    check_unique_id
    if page.save
      page
    else
      false
    end
  end

  private

  def check_unique_id
    CreateUniqueId.call(page)
  end
end
