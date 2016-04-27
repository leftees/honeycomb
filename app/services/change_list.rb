# Provides a list of changes associated with a papertrail enabled object
class ChangeList
  def self.call(papertrail_object:)
    result = []
    versions = papertrail_object.versions
    versions.each do |v|
      user = User.find_by_id(v.whodunnit)
      user_name = user.present? ? user.name : nil
      v1 = v
      v2 = v.next

      a1 = deserialize(version: v1)
      a2 = v2.present? ? deserialize(version: v2) : papertrail_object.attributes

      a1.delete("updated_at")
      a2.delete("updated_at")

      new = a2.to_a - a1.to_a
      previous = a1.to_a - a2.to_a

      result << { date: v.created_at, user_id: v.whodunnit, user_name: user_name, event: v.event, previous: previous, new: new }
    end
    result
  end

  def self.deserialize(version:)
    version.object.present? ? PaperTrail.serializer.load(version.object) : {}
  end
end
