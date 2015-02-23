require 'rails'

describe AdministratorQuery do
  subject {described_class.new(relation)}
  let(:relation) { User.all }
  let(:modified_relation) { User.all.where(admin: true) }

  describe '#relation' do
    it "adds .where(admin: true)" do
      expect(relation).to receive(:where).with(admin: true).and_return(modified_relation)
      expect(subject.relation).to eq(modified_relation)
    end
  end

  describe "build" do

    it "builds a object off of the relation and returns the result" do
      expect(subject.relation).to receive(:build).and_return('build')
      expect(subject.build).to eq('build')
    end

    it 'builds a user' do
      expect(subject.build).to be_a_kind_of(User)
    end

    it 'sets admin to true' do
      user = subject.build
      expect(user.admin).to be(true)
    end

    it "accepts default arguments" do
      user = subject.build(username: 'test')
      expect(user.username).to eq('test')
    end
  end

end
