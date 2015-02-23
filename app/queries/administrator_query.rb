class AdministratorQuery
  attr_reader :relation

  def initialize(relation = User.all)
    @relation = relation.where(admin: true)
  end

  def find(id)
    relation.find(id)
  end

  def build(*args)
    relation.build(*args)
  end
end
