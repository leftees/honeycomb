require 'rails_helper'

RSpec.describe ItemsController, type: :controller do
  let(:relation) { Item.all }

  let(:publish_params) { { id: item.id } }

  before(:each) do
    sign_in_admin
  end

  describe 'GET #index' do
    let(:collection) { double(Collection, id: 1, items: relation) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    subject { get :index, collection_id: collection.id }

    it 'returns a 200' do
      subject

      expect(response).to be_success
      expect(response).to render_template('index')
    end

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'users the item query to get items' do
      expect_any_instance_of(ItemQuery).to receive(:only_top_level).and_return([])
      subject
    end

    it 'assigns an item decorator to items' do
      subject
      assigns(:items)
      expect(assigns(:items)).to be_a(ItemsDecorator)
    end

    it "sets the etag" do
      subject
      expect(response.etag).not_to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]
      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'GET #new' do
    let(:collection) { double(Collection, id: 1, items: relation) }
    let(:item) { double(Item, id: '1', collection: collection) }

    before(:each) do
      allow_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    subject { get :new, collection_id: collection.id }

    it 'returns a 200' do
      subject

      expect(response).to be_success
      expect(response).to render_template('new')
    end

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses item query ' do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      subject
    end

    it 'assigns and item and it is an item decorator' do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it "does not set the etag" do
      subject
      expect(response.etag).to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'POST #create' do
    let(:collection) { double(Collection, id: 1, items: relation) }
    let(:create_params) { { collection_id: collection.id, item: { title: 'title' } } }
    let(:item) { double(Item, id: 1, parent: nil, collection: collection) }

    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
      allow_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      allow(SaveItem).to receive(:call).and_return(true)
    end

    subject { post :create, create_params }

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses item query ' do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      subject
    end

    it 'redirects on success' do
      expect_any_instance_of(described_class).to receive(:item_save_success).and_call_original

      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'renders new on failure' do
      allow(SaveItem).to receive(:call).and_return(false)

      subject
      expect(response).to render_template('new')
    end

    it 'assigns and item' do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it 'uses the save item service' do
      expect(SaveItem).to receive(:call).and_return(true)

      subject
    end

    it "does not set the etag" do
      subject
      expect(response.etag).to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'GET #edit' do
    let(:collection) { double(Collection, id: '1') }
    let(:item) { double(Item, id: '1', collection: collection) }

    before(:each) do
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
    end

    subject { get :edit, id: item.id }

    it 'returns a 200' do
      subject

      expect(response).to be_success
      expect(response).to render_template('edit')
    end

    it 'uses item query' do
      expect_any_instance_of(ItemQuery).to receive(:find).with('1').and_return(item)
      subject
    end

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'assigns and item and it is an item decorator' do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(ItemDecorator)
    end

    it "sets the etag" do
      subject
      expect(response.etag).not_to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'PUT #update' do
    let(:collection) { double(Collection, id: '1') }
    let(:item) { double(Item, id: 1, parent: nil, collection: collection) }
    let(:update_params) { { id: item.id, item: { title: 'title' } } }

    subject { put :update, update_params }

    before(:each) do
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
      allow(SaveItem).to receive(:call).and_return(true)
    end

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses item query ' do
      expect_any_instance_of(ItemQuery).to receive(:find).with('1').and_return(item)
      subject
    end

    it 'redirects on success' do
      expect_any_instance_of(described_class).to receive(:item_save_success).and_call_original

      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'renders new on failure' do
      allow(SaveItem).to receive(:call).and_return(false)

      subject
      expect(response).to render_template('edit')
    end

    it 'assigns and item' do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it 'uses the save item service' do
      expect(SaveItem).to receive(:call).and_return(true)

      subject
    end

    it "does not set the etag" do
      subject
      expect(response.etag).to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'DELETE #destroy' do
    let(:collection) { double(Collection, id: '1') }
    let(:item) { double(Item, id: 1, collection: collection, destroy!: true) }

    subject { delete :destroy, id: item.id }

    before(:each) do
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
    end

    it 'calls destroy on the item on success, redirects, and flashes ' do
      expect(item).to receive(:destroy!).and_return(true)

      subject
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'assigns and item' do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses item query ' do
      expect_any_instance_of(ItemQuery).to receive(:find).with('1').and_return(item)
      subject
    end

    it "does not set the etag" do
      subject
      expect(response.etag).to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'PUT #publish' do
    let(:collection) { double(Collection, id: '1') }
    let(:item) { double(Item, id: 1, collection: collection, 'published=' => true, parent: nil) }

    before(:each) do
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
      allow(Publish).to receive(:call).and_return(true)
    end

    subject { put :publish, publish_params }

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses item query ' do
      expect_any_instance_of(ItemQuery).to receive(:find).with('1').and_return(item)
      subject
    end

    it 'redirects on success' do
      expect_any_instance_of(described_class).to receive(:item_save_success).and_call_original
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'uses the save item service' do
      expect(Publish).to receive(:call).and_return(true)

      subject
    end

    it "does not set the etag" do
      subject
      expect(response.etag).to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end

  describe 'PUT #unpublish' do
    let(:collection) { double(Collection, id: '1') }
    let(:item) { double(Item, id: 1, collection: collection, 'published=' => true, parent: nil) }

    before(:each) do
      allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
      allow(Unpublish).to receive(:call).and_return(true)
    end

    subject { put :unpublish, publish_params }

    it 'checks the editor permissions' do
      expect_any_instance_of(described_class).to receive(:check_user_edits!).with(collection)
      subject
    end

    it 'uses item query ' do
      expect_any_instance_of(ItemQuery).to receive(:find).with('1').and_return(item)
      subject
    end

    it 'redirects on success' do
      expect_any_instance_of(described_class).to receive(:item_save_success).and_call_original
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it 'uses the save item service' do
      expect(Unpublish).to receive(:call).and_return(true)

      subject
    end

    it "does not set the etag" do
      subject
      expect(response.etag).to be(nil)
    end

    it "does not set the last modified date" do
      subject
      expect(response.last_modified).to be(nil)
    end

    it "does not set a max-age other than 0" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil? || cache_control.match(/max-age/).nil?
        expect(cache_control.match(/max-age=0/)).not_to be(nil)
      end
    end

    it "does not set cache control to public" do
      subject
      cache_control = response.headers["Cache-Control"]

      unless cache_control.nil?
        expect(cache_control.match(/public/)).to be(nil)
      end
    end
  end
end
