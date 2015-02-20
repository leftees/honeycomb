require "rails_helper"

RSpec.describe ItemsController, :type => :controller do
  let(:item) { instance_double(Item, id: 1, title: 'title', collection: collection, destroy!: true) }
  let(:collection) { instance_double(Collection, id: 1, title: 'title', items: relation) }
  let(:relation) { Item.all }
  let(:create_params) { {collection_id: collection.id, item: { title: 'title' }} }
  let(:update_params) { {id: item.id, item: { title: 'title' }} }

  let(:user) {
    u = User.new(username: 'jhartzler', admin: true)
    u.save!

    u
  }

  before(:each) do
    sign_in user

    allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    allow_any_instance_of(ItemQuery).to receive(:find).and_return(item)
    allow(SaveItem).to receive(:call).and_return(true)
  end

  describe "GET #index" do
    subject { get :index, collection_id: collection.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "users the item query to get items" do
      expect_any_instance_of(ItemQuery).to receive(:only_top_level)
      subject
    end

    it "assigns an item decorator to items" do
      subject
      assigns(:items)
      expect(assigns(:items)).to be_a(ItemsDecorator)
    end
  end


  describe "GET #new" do
    subject { get :new, collection_id: collection.id }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("new")
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(Item)
    end
  end


  describe "POST #create" do
    subject { post :create, create_params }

    before(:each) do
      allow(SaveItem).to receive(:call).and_return(true)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:build).and_return(item)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveItem).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("new")
    end

    it "assigns and item" do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(Item)
    end

    it "uses the save item service" do
      expect(SaveItem).to receive(:call).and_return(true)

      subject
    end
  end

  describe "GET #edit" do
    subject { get :edit, id: 1 }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("edit")
    end

    it "uses item query" do
      expect_any_instance_of(ItemQuery).to receive(:find).with("1").and_return(item)
      subject
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "assigns and item and it is an item decorator" do
      subject

      assigns(:item)
      expect(assigns(:item)).to be_a(ItemDecorator)
    end
  end


  describe "PUT #update" do
    subject { put :update, update_params }

    before(:each) do
      allow(SaveItem).to receive(:call).and_return(true)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:find).with("1").and_return(item)
      subject
    end

    it "redirects on success" do
      subject

      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "renders new on failure" do
      allow(SaveItem).to receive(:call).and_return(false)

      subject
      expect(response).to render_template("edit")
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
  end


  describe "DELETE #destroy" do
    subject { delete :destroy, id: item.id }

    it "calls destroy on the item on success, redirects, and flashes " do
      expect(item).to receive(:destroy!).and_return(true)

      subject
      expect(response).to be_redirect
      expect(flash[:notice]).to_not be_nil
    end

    it "assigns and item" do
      subject

      assigns(:item)
      expect(assigns(:item)).to eq(item)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "uses item query " do
      expect_any_instance_of(ItemQuery).to receive(:find).with("1").and_return(item)
      subject
    end
  end
end
