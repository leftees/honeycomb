require "draper"

class DeletePanel < Draper::Decorator
  attr_accessor :path

  # If providing a query_object, it must implement "can_delete"
  def display(query_object = nil)
    yield(self) if block_given?

    # for now allow the delete when no query object is given to
    # retain the current behavior for all other objects
    can_delete = true
    if query_object
      can_delete = query_object.can_delete
    end
    h.render partial: "shared/delete_panel", locals: { default_name: default_name, path: path, i18n_key_base: i18n_key_base, can_delete: can_delete }
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
