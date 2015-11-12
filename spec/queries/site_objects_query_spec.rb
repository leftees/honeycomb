require "rails"
require "rails_helper"

describe SiteObjectsQuery do
  let(:showcases) do
    [
      instance_double(Showcase, id: 0, collection_id: 1, class: double(Object, name: "Showcase")),
      instance_double(Showcase, id: 1, collection_id: 1, class: double(Object, name: "Showcase")),
      instance_double(Showcase, id: 2, collection_id: 1, class: double(Object, name: "Showcase"))
    ]
  end
  let(:pages) do
    [
      instance_double(Page, id: 0, collection_id: 1, class: double(Object, name: "Page")),
      instance_double(Page, id: 1, collection_id: 1, class: double(Object, name: "Page")),
      instance_double(Page, id: 2, collection_id: 1, class: double(Object, name: "Page"))
    ]
  end
  let(:users) do
    [
      instance_double(User, id: 0, class: double(Object, name: "User")),
      instance_double(User, id: 1, class: double(Object, name: "User")),
      instance_double(User, id: 2, class: double(Object, name: "User"))
    ]
  end
  let(:site_objects_string) { '[{ "type": "Showcase", "id": 0 }, { "type": "Page", "id": 2 }, { "type": "Showcase", "id": 2 }]' }
  let(:site_objects) { [showcases[0], pages[2], showcases[2]] }
  let(:collection) { instance_double(Collection, id: 1, site_objects: site_objects_string) }

  before(:each) do
    allow(Collection).to receive(:find).and_return(collection)
    allow(Showcase).to receive(:find) do |id|
      showcases[id]
    end
    allow(Page).to receive(:find) do |id|
      pages[id]
    end
    allow(User).to receive(:find) do |id|
      users[id]
    end
  end

  it "returns all site objects as a json" do
    expect(subject.all(collection: collection)).to eq(site_objects)
  end

  context "when finding previous" do
    it "returns nil if the object given is not in the site_objects array" do
      expect(subject.previous(collection_object: showcases[1])).to eq(nil)
    end

    it "finds the previous object" do
      expect(subject.previous(collection_object: pages[2])).to eq(showcases[0])
    end

    it "returns nil if there is no previous object" do
      # Since there are multiple paths to return nil, this first expectation is to ensure
      # that it finds the object
      expect(subject.next(collection_object: showcases[0])).to eq(pages[2])
      expect(subject.previous(collection_object: showcases[0])).to eq(nil)
    end
  end

  context "when finding next" do
    it "returns nil if the object given is not in the site_objects array" do
      expect(subject.next(collection_object: showcases[1])).to eq(nil)
    end

    it "finds the next object" do
      expect(subject.next(collection_object: pages[2])).to eq(showcases[2])
    end

    it "returns nil if there is no next object" do
      # Since there are multiple paths to return nil, this first expectation is to ensure
      # that it finds the object
      expect(subject.previous(collection_object: showcases[2])).to eq(pages[2])
      expect(subject.next(collection_object: showcases[2])).to eq(nil)
    end
  end

  context "invalid object types" do
    let(:site_objects_string) { '[{ "type": "Showcase", "id": 0 }, { "type": "User", "id": 2 }, { "type": "Showcase", "id": 2 }]' }
    let(:site_objects) { [showcases[0], users[2], showcases[2]] }

    it "raises an exception" do
      expect { subject.all(collection: collection) }.to raise_error
    end
  end
end
