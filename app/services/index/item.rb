module Index
  module Item
    def self.index!(item)
      index_item = item_to_waggle_item(item)
      Waggle.index!(index_item)
    rescue StandardError => exception
      notify_error(exception: exception, item: item, action: "index!")
    end

    def self.remove!(item)
      index_item = item_to_waggle_item(item)
      Waggle.remove!(index_item)
    rescue StandardError => exception
      notify_error(exception: exception, item: item, action: "remove!")
    end

    def self.item_to_waggle_item(item)
      Waggle::Item.from_item(item)
    end
    private_class_method :item_to_waggle_item

    def self.notify_error(exception:, item:, action:)
      NotifyError.call(exception: exception, parameters: { item: item }, component: to_s, action: action)
    end
    private_class_method :notify_error
  end
end
