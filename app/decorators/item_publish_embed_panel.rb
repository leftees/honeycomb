require 'draper'

class ItemPublishEmbedPanel < Draper::Decorator

  def self.display(item)
    self.new(item).display
  end

  def display
    h.react_component('ItemPublishEmbedPanel', component_parameters)
  end

  private

  def i18n_key_base
    @base ||= "items.edit"
  end

  def component_parameters
    {
      publish_panel_title: h.t("#{i18n_key_base}.publish"),
      publish_panel_help: h.t("#{i18n_key_base}.publish_help"),
      publish_panel_field_name: h.t("#{i18n_key_base}.publish_field"),
      embed_panel_title: h.t("#{i18n_key_base}.embed"),
      embed_panel_help: h.t("#{i18n_key_base}.embed_help"),
      published: !!object.published
    }
  end
end
