# Performs batch creation of items from a json
class CreateItems
  def self.call(collection_id:, items_hash:, rewrite_rules: nil)
    new.create!(collection_id: collection_id, items_hash: items_hash, rewrite_rules: rewrite_rules)
  end

  def create!(collection_id:, items_hash:, rewrite_rules: nil)
    ActiveRecord::Base.transaction do
      items_hash.each do |item_props|
        unless rewrite_rules.nil?
          rewrite_rules.each do |rewrite_rule|
            item_props = rewrite_rule.rewrite(item_hash: item_props)
          end
        end
        item_props[:collection_id] = collection_id
        item = Item.new(item_props)
        unless SaveItem.call(item, item_props)
          # Dumb way to handle presenting invalid records for now
          raise item.errors.messages.to_s
        end
      end
    end
  end
end
