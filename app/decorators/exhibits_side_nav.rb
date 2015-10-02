class ExhibitsSideNav < Draper::Decorator
  attr_reader :exhibit, :form

  def initialize(exhibit:, form:)
    @exhibit = exhibit
    @form = form
  end

  def site_intro_link
    h.link_to("Site Introduction", h.edit_exhibit_path(exhibit))
  end

  def exhibit_introduction_link
    h.link_to("Exhibit Introduction", h.edit_exhibit_form_exhibit_path(exhibit, form: "exhibit_introduction"))
  end

  def about_text_link
    h.link_to("About Text", h.edit_exhibit_form_exhibit_path(exhibit, form: "about_text"))
  end

  def copyright_link
    h.link_to("Copyright Text", h.edit_exhibit_form_exhibit_path(exhibit, form: "copyright_text"))
  end

  def search_and_browse_link
    h.link_to("Search and Browse", h.edit_exhibit_form_exhibit_path(exhibit, form: "search_and_browse"))
  end

  def active_tab_class(tab:)
    return "active" if tab == form
    return "active" if tab == "edit" && form.nil?
    ""
  end
end
