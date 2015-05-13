require "rails"
require "rails_helper"

describe ShowcaseQuery do
  subject { described_class.new(relation) }
  let(:relation) { Showcase.all }

  describe "#relation" do
    it "returns the relation" do
      expect(subject.relation).to eq(relation)
    end
  end

  describe "all" do
    it "returns all the showcases" do
      expect(subject.all).to eq(relation)
    end
  end

  describe "public_api_list" do
    it "orders the result" do
      expect(relation).to receive(:order).with(:order, :title).and_return(relation)
      subject.public_api_list
    end
  end

  describe "admin_list" do
    it "orders the result" do
      expect(relation).to receive(:order).with(:order, :title).and_return(relation)
      subject.admin_list
    end
  end

  describe "find" do
    it "finds the object" do
      expect(relation).to receive(:find).with(1)
      subject.find(1)
    end
  end

  describe "build" do
    it "builds a object off of the relation" do
      expect(relation).to receive(:build)
      subject.build
    end

    it "accepts default arguments" do
      item = subject.build(exhibit_id: 1)
      expect(item.exhibit_id).to eq(1)
    end
  end


  describe "public_find" do
    it "calls public_find!" do
      expect(relation).to receive(:find_by!).with(unique_id: "asdf")
      subject.public_find("asdf")
    end

    it "raises an error on not found" do
      expect { subject.public_find("asdf") }.to raise_error ActiveRecord::RecordNotFound
    end
  end

  describe "next" do
    it "finds the correct showcase when there is one" do
      showcase1 = FactoryGirl.build(:showcase_with_exhibit, id: 1, order: 1)
      showcase2 = FactoryGirl.create(:showcase_with_exhibit, id: 2, order: 2)
      expect(subject.next(showcase1)).to eq(showcase2)
    end
  end

  describe "previous" do
    it "finds the correct showcase when there is one" do
      showcase1 = FactoryGirl.create(:showcase_with_exhibit, id: 1, order: 1)
      showcase2 = FactoryGirl.build(:showcase_with_exhibit, id: 2, order: 2)
      expect(subject.previous(showcase2)).to eq(showcase1)
    end
  end
end
