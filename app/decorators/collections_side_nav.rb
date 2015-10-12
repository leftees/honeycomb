class CollectionsSideNav < Draper::Decorator
  attr_reader :collection, :form

  def initialize(collection:, form:)
    @collection = collection
    @form = form
  end

  def homepage_link
    "TODO: Homepage link"
  end

  def collection_introduction_link
    "TODO: Introduction link"
    #h.link_to("Collection Introduction", h.edit_collection_form_collection_path(collection, form: "collection_introduction"))
  end

  def about_text_link
    h.link_to("About Text", h.edit_collection_form_collection_path(collection, form: "about_text"))
  end

  def active_tab_class(tab:)
    return "active" if tab == form
    return "active" if tab == "edit" && form.nil?
    ""
  end
end
