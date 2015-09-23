class CollectionQuery
  attr_reader :relation

  def initialize(relation = Collection.all)
    @relation = relation
  end

  def for_top_nav(user, collection)
    for_editor(user).order(updated_at: :desc).where.not(id: collection.id)
  end

  # where collection != external collection
  def for_editor(user)
    if UserIsAdmin.call(user)
      relation.all.joins(:exhibit).where(exhibits: { url: nil })
    else
      user.collections.joins(:exhibit).where(exhibits: { url: nil })
    end
  end

  def public_collections
    relation.where("published = ?", true)
  end

  def public_find(id)
    relation.where(
      "unique_id = ? AND (published = ? OR preview_mode = ?)",
      id, true, true
    ).take!
  end

  def any_find(id)
    relation.find_by!(unique_id: id)
  end

  def recent(limit = 5)
    relation.order(updated_at: :desc).limit(limit)
  end

  delegate :find, to: :relation

  delegate :build, to: :relation
end
