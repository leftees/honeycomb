require 'draper'

class DeleteSection < Draper::Decorator
  attr_accessor :name, :message, :path

  def display
    yield(self) if block_given?

    h.render partial: 'shared/delete_section', locals: { name: name, message: message, path: path }
  end

  def name
    @name || object.class.to_s
  end

  def message
    @message || "Procede with caution. This will remove the #{name} and all associated data. "
  end

  def path
    @path || object
  end
end
