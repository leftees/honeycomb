# Provides a list of changes associated with a papertrail enabled object
class ChangeList
  def self.call(papertrail_object:)
    result = []
    versions = papertrail_object.versions
    versions.each do |v|
      user = User.find_by_id(v.whodunnit)
      user_name = user.present? ? user.name : nil
      diff = changes(version: v,  current_attributes: papertrail_object.attributes)
      result << { date: v.created_at, user_id: v.whodunnit, user_name: user_name, event: v.event, previous: diff[:previous], new: diff[:new] }
    end
    result
  end

  def self.deserialize(version:)
    version.object.present? ? PaperTrail.serializer.load(version.object) : {}
  end

  # Gets the changes associated with a version. current_attributes must be the attributes
  # of the object in it's current state (not a version)
  def self.changes(version:, current_attributes:)
    next_version = version.next

    attr = deserialize(version: version)
    next_attr = next_version.present? ? deserialize(version: next_version) : current_attributes

    attr.delete("updated_at")
    next_attr.delete("updated_at")

    new = next_attr.to_a - attr.to_a
    previous = attr.to_a - next_attr.to_a

    { previous: previous, new: new }
  end
end
