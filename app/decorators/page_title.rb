require 'draper'


class PageTitle < Draper::Decorator
  attr_accessor :small_title, :title_href, :small_title_href, :settings_href

  def display()
    yield(self) if block_given?

    h.render partial: 'shared/page_title', locals: { title: title_with_link, small_title: small_title_with_link, settings_link: settings_link }
  end

  private

    def title_with_link
      if title_href.present?
        h.link_to(object, title_href)
      else
        object
      end
    end

    def small_title_with_link
      if small_title
        if small_title_href
          h.raw("/ " + h.link_to(small_title, small_title_href))
        else
          "/ " + small_title
        end
      else
        ""
      end
    end


    def settings_link
      if settings_href
        h.link_to(h.raw('<i class="glyphicon glyphicon-cog"></i> Settings'), settings_href, class: 'btn btn-sm', role: 'button')
      else
        ""
      end
    end

end

