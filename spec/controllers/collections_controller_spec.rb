require "rails_helper"
require "cache_spec_helper"

RSpec.describe CollectionsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1, name_line_1: "COLLECTION", destroy!: true, collection_users: [], showcases: [], pages: [], items: []) }

  let(:create_params) { { collection: { name_line_1: "TITLE!!" } } }
  let(:update_params) { { id: "1", published: true, collection: { name_line_1: "TITLE!!" } } }

  before(:each) do
    @user = sign_in_admin
  end

  describe "index" do
    subject { get :index }

    it "uses the query object" do
      expect_any_instance_of(CollectionQuery).to receive(:for_editor).with(@user)
      subject
    end

    it "is a success" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Collections#index to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:index)
      subject
    end
  end

  describe "show" do
    subject { get :show, id: collection.id }
    it "redirects to the items page" do
      subject

      expect(response).to redirect_to collection_items_path(collection.id)
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "new" do
    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
      get :new
    end

    it "calls CollectionQuery to get the collection" do
      expect_any_instance_of(CollectionQuery).to receive(:build).and_return(Collection.new)
      get :new
    end

    it "loads a new collection" do
      get :new
      assigns(:collection)
      expect(assigns(:collection)).to be_a(Collection)
    end

    it "is a success" do
      get :new
      expect(response).to be_success
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { get :new }
    end
  end

  describe "create" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:build).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
      post :create, create_params
    end

    it "calls the save service" do
      expect(SaveCollection).to receive(:call)
      post :create, create_params
    end

    it "assigns a collection" do
      post :create, create_params

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "redirects on success" do
      post :create, create_params
      expect(response).to be_redirect
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      post :create, create_params
      expect(response).to render_template(:new)
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { post :create, create_params }
    end
  end

  describe "edit" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      get :edit, id: 1
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      get :edit, id: 1
    end

    it "is a success" do
      get :edit, id: 1
      expect(response).to be_success
    end

    it_behaves_like "a private basic custom etag cacher" do
      subject { get :edit, id: 1 }
    end

    it "uses the Collections#edit to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:edit)
      get :edit, id: 1
    end
  end

  describe "update" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      put :update, update_params
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      put :update, update_params
    end

    it "assigns a collection" do
      put :update, update_params

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "redirects on success" do
      put :update, update_params
      expect(response).to be_redirect
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      put :update, update_params
      expect(response).to render_template(:edit)
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { put :update, update_params }
    end
  end

  describe "destroy" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)

      delete :destroy, id: "1"
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      delete :destroy, id: "1"
    end

    it "redirects on success " do
      delete :destroy, id: "1"
      expect(response).to be_redirect
    end

    it "uses the Destroy::Collection.cascade! method" do
      expect_any_instance_of(Destroy::Collection).to receive(:cascade!)
      delete :destroy, id: "1"
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { delete :destroy, id: "1" }
    end
  end

  describe "publish" do
    let(:collection_to_publish) { Collection.new(id: 1) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection_to_publish)
      allow(collection_to_publish).to receive(:save).and_return(true)
    end

    it "checks the editor permissions" do
      expect_any_instance_of(CollectionsController).to receive(:check_user_edits!).with(collection_to_publish)
      put :publish, update_params
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection_to_publish)
      put :publish, update_params
    end

    it "publishes a collection" do
      put :publish, update_params
      expect(collection_to_publish.published).to be_truthy
    end

    it "redirects on success" do
      put :publish, update_params
      expect(response).to be_redirect
    end
  end

  describe "unpublish" do
    let(:collection_to_unpublish) { Collection.new(id: 1, published: true) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection_to_unpublish)
      allow(collection_to_unpublish).to receive(:save).and_return(true)
      update_params[:published] = false
    end

    it "checks the editor permissions" do
      expect_any_instance_of(CollectionsController).to receive(:check_user_edits!).with(collection_to_unpublish)
      put :unpublish, update_params
    end

    it "uses collection query to get the colletion" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection_to_unpublish)
      put :unpublish, update_params
    end

    it "unpublishes a collection" do
      put :unpublish, update_params
      expect(collection_to_unpublish.published).to be_falsey
    end

    it "redirects on success" do
      put :unpublish, update_params
      expect(response).to be_redirect
    end
  end

  describe "site_setup" do
    subject { get :site_setup, id: collection.id }
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses collection query" do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      subject
    end

    it "assigns a collection" do
      subject

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it_behaves_like "a private basic custom etag cacher"

    it "uses the Collection#site_setup to generate the cache key" do
      expect_any_instance_of(CacheKeys::Custom::Collections).to receive(:site_setup)
      subject
    end
  end

  describe "site_setup_update" do
    let(:update_params) { { id: "1", published: true, form: "homepage", collection: { name_line_1: "TITLE!!" } } }
    subject { put :site_setup_update, update_params }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow(SaveCollection).to receive(:call).and_return(true)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it "uses collection query " do
      expect_any_instance_of(CollectionQuery).to receive(:find).with("1").and_return(collection)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("site_setup")
    end

    it "assigns a collection" do
      subject

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "uses the save collection service" do
      expect(SaveCollection).to receive(:call).with(collection, update_params[:collection]).and_return(true)

      subject
    end

    it_behaves_like "a private content-based etag cacher"
  end

  describe "image_upload" do
    let(:honeypot_image) { HoneypotImage.new(item_id: 1) }
    let(:json_response) { { "thumbnail/medium" => { "contentUrl" => "http://honeypot/image" } } }
    let(:collection) { Collection.new(unique_id: "test", items: []) }
    let(:item) { Item.new(id: 1, name: "test_item", unique_id: "test", collection: collection) }
    let(:image) { double(path: Rails.root.join("spec/fixtures/test.jpg").to_s, content_type: "image/jpeg") }
    let(:image_params) { { id: "test", uploaded_image: fixture_file_upload("test.jpg", "image/jpeg", :binary) } }
    # let(:item_query) { ItemQuery.new }
    subject { post :image_upload, image_params }

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
end
