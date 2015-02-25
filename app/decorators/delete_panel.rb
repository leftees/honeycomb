require 'draper'

class DeletePanel < Draper::Decorator
  attr_accessor :path

  def display
    yield(self) if block_given?

    h.render partial: 'shared/delete_panel', locals: { default_name: default_name, path: path, i18n_key_base: i18n_key_base }
  end

  def default_name
    object.class.to_s
  end

  def path
    @path || object
  end

  def i18n_key_base
    "#{object.class.to_s.downcase.pluralize}.delete_panel"
  end
end
