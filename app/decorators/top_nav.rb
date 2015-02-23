require 'draper'

class TopNav < Draper::Decorator

  def display
    h.render partial: 'shared/top_nav', locals: { nav: self }
  end

  def current_user_display_name
    if object.respond_to?(:current_user) && object.current_user
      object.current_user.display_name
    else
      "no user"
    end
  end

end
