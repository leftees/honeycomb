require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::ItemsController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, items: nil) }
  let(:item) { instance_double(Item, id: "1", collection: nil, children: nil) }

  before(:each) do
    allow_any_instance_of(ItemQuery).to receive(:public_find).and_return(item)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe "#index" do
    subject { get :index, collection_id: collection.id, format: :json }
    it "calls CollectionQuery" do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).with(collection.id).and_return(collection)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template("v1/items/index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Items#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Items).to receive(:index)
      subject
    end
  end

  describe "#show" do
    subject { get :show, id: "id", format: :json }
    it "calls ItemQuery" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("id").and_return(item)

      subject
    end

    it "is successful" do
      subject

      expect(response).to be_success
      expect(assigns(:item)).to be_present
      expect(subject).to render_template("v1/items/show")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Items#show to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Items).to receive(:show)
      subject
    end
  end

  describe "PUT #update" do
    let(:collection) { double(Collection, id: "1") }
    let(:item) { double(Item, id: 1, parent: nil, collection: collection) }
    let(:update_params) { { format: :json, id: item.id, item: { title: "title" } } }
    subject { put :update, update_params }

    before(:each) do
      sign_in_admin
      allow(SaveItem).to receive(:call).and_return(true)
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:user_can_edit?).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("1").and_return(item)
      subject
    end

    it "returns ok on success" do
      subject
      expect(response).to be_success
    end

    it "renders the item only on success" do
      subject
      expect(response).to render_template("update")
    end

    it "returns unprocessable on failure" do
      allow(SaveItem).to receive(:call).and_return(false)
      subject
      expect(response).to be_unprocessable
    end

    it "renders with errors" do
      allow(SaveItem).to receive(:call).and_return(false)
      subject
      expect(item).to render_template("errors")
    end

    it "assigns and item" do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it "uses the save item service" do
      expect(SaveItem).to receive(:call).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "#showcases" do
    subject { get :showcases, item_id: "id", format: :json }
    let(:item) { instance_double(Item, id: "1", collection: nil, children: nil, showcases: nil) }

    it "calls ItemQuery" do
      expect_any_instance_of(ItemQuery).to receive(:public_find).with("id").and_return(item)

      subject
    end

    it "is successful" do
      subject
      expect(response).to be_success
    end

    it "assigns the item to render" do
      subject
      expect(assigns(:item)).to be_present
    end

    it "renders the correct template" do
      expect(subject).to render_template("v1/items/showcases")
      subject
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the V1Items#showcases to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::V1Items).to receive(:showcases)
      subject
    end
  end

  describe "#images" do
    let(:json_response_1) { { "thumbnail/small" => { "contentUrl" => "http://hnypt/sm_img1" }, "thumbnail/medium" => { "contentUrl" => "http://hnypt/img1" } } }
    let(:json_response_2) { { "thumbnail/small" => { "contentUrl" => "http://hnypt/sm_img2" }, "thumbnail/medium" => { "contentUrl" => "http://hnypt/img2" } } }
    let(:json_response_3) { { "thumbnail/small" => { "contentUrl" => "http://hnypt/sm_img3" }, "thumbnail/medium" => { "contentUrl" => "http://hnypt/img3" } } }
    let(:item1) { double(Item, id: 1, name: "test_item", unique_id: "test", collection: collection2, honeypot_image: honeypot_image1) }
    let(:item2) { double(Item, id: 2, name: "test_item2", unique_id: "test2", collection: collection2, honeypot_image: honeypot_image2) }
    let(:item3) { double(Item, id: 3, name: "test_item3", unique_id: "test3", collection: collection2, honeypot_image: honeypot_image3) }
    let(:honeypot_image1) { double(HoneypotImage, item_id: 1, json_response: json_response_1) }
    let(:honeypot_image2) { double(HoneypotImage, item_id: 2, json_response: json_response_2) }
    let(:honeypot_image3) { double(HoneypotImage, item_id: 3, json_response: json_response_3) }
    let(:collection2) { double(Collection, unique_id: "test", items: []) }
    subject { get :images, format: "json", collection_id: "text" }

    before(:each) do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection2)
      expect(collection2).to receive(:items).and_return([item1, item2, item3])
    end

    it "returns the full list of image items" do
      subject

      expect(response.body).to eq ([
        { unique_id: "test", thumb: "http://hnypt/sm_img1", image: "http://hnypt/img1", title: "test_item" },
        { unique_id: "test2", thumb: "http://hnypt/sm_img2", image: "http://hnypt/img2", title: "test_item2" },
        { unique_id: "test3", thumb: "http://hnypt/sm_img3", image: "http://hnypt/img3", title: "test_item3" }
      ].to_json)
    end
  end
end
