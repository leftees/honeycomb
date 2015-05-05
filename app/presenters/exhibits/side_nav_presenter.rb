class Exhibits::SideNavPresenter < Curly::Presenter
  presents :exhibit, :form

  def site_intro_link
    link_to("Site Introduction", edit_exhibit_path(@exhibit))
  end

  def exhibit_introduction_link
    link_to("Exhibit Introduction", edit_exhibit_form_exhibit_path(@exhibit, form: 'exhibit_introduction'))
  end

  def about_text_link
    link_to('About Text', edit_exhibit_form_exhibit_path(@exhibit, form: 'about_text'))
  end

  def copyright_link
    link_to('Copyright Text', edit_exhibit_form_exhibit_path(@exhibit, form: 'copyright_text'))
  end

  def active_tab_class(tab:)
    return "active" if tab == @form
    return "active" if tab == "edit" && @form.nil?
  end
end
