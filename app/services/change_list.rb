# Provides a list of changes associated with a papertrail enabled object
class ChangeList
  def self.call(papertrail_object:)
    result = []
    versions = papertrail_object.versions
    versions.each do |v|
      user = User.find_by_id(v.whodunnit)
      user_name = user.present? ? user.name : v.whodunnit
      v1 = v
      v2 = v.next

      a1 = v1.object.present? ? PaperTrail.serializer.load(v1.object) : {}
      if v2.present?
        a2 = v2.object.present? ? PaperTrail.serializer.load(v2.object) : {}
      else
        a2 = papertrail_object.attributes
      end

      a1 = a1.tap { |hs| hs.delete("updated_at") }
      a2 = a2.tap { |hs| hs.delete("updated_at") }
      new = a2.to_a - a1.to_a
      previous = a1.to_a - a2.to_a
      result << { date: v.created_at, user_id: v.whodunnit, user_name: user_name, previous: previous, new: new }
    end
    result
  end
end
