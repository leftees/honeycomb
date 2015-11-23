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

  describe "#create" do
    let(:honeypot_image) { HoneypotImage.new(item_id: 1) }
    let(:json_response) { { "thumbnail/medium" => { "contentUrl" => "http://honeypot/image" } } }
    let(:collection) { Collection.new(unique_id: "test", items: []) }
    let(:item) { Item.new(id: 1, name: "test_item", unique_id: "test", collection: collection) }
    let(:image) { double(path: Rails.root.join("spec/fixtures/test.jpg").to_s, content_type: "image/jpeg") }
    let(:image_params) { { collection_id: "test", uploaded_image: fixture_file_upload("test.jpg", "image/jpeg", :binary) } }
    subject { post :create, image_params }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:any_find).and_return(collection)
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
      allow(Item).to receive(:last).and_return(item)
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
    end

    context "when successfully uploaded" do
      it "uploads the image" do
        expect(SaveItem).to receive(:call).and_return(true)
        expect(item).to receive(:honeypot_image).and_return(honeypot_image)
        expect(honeypot_image).to receive(:json_response).and_return(json_response)
        subject
        expect(response).to be_success
      end

      it "returns the correct json" do
        expect(SaveItem).to receive(:call).and_return(true)
        expect(item).to receive(:honeypot_image).and_return(honeypot_image)
        expect(honeypot_image).to receive(:json_response).and_return(json_response)
        subject
        expect(response.body).to eq ({ filelink: "http://honeypot/image", title: item.name, unique_id: item.unique_id }.to_json)
      end

      it "sets the success flash message" do
        expect(SaveItem).to receive(:call).and_return(true)
        expect(item).to receive(:honeypot_image).and_return(honeypot_image)
        expect(honeypot_image).to receive(:json_response).and_return(json_response)
        subject
        expect(flash[:success]).to_not be_nil
      end
    end

    context "when not successfully uploaded" do
      it "does not return success" do
        expect(SaveItem).to receive(:call).and_return(false)
        subject
        expect(response).to be_error
      end

      it "returns the error json" do
        expect(SaveItem).to receive(:call).and_return(false)
        subject
        expect(response.body).to eq ({ status: "error" }.to_json)
      end
    end
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
end
