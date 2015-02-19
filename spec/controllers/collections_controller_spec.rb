require "rails_helper"

RSpec.describe CollectionsController, :type => :controller do
  let(:collection) { instance_double(Collection, id: 1, valid?: true) }
  let(:invalid_collection) { instance_double(Collection, id: nil, valid?: false) }

  let(:collections) { [collection] }
  let(:params) { {collection: {title: "TITLE!!" }}}

  let(:user) {
    u = User.new(username: 'jhartzler', admin: true)
    u.save!

    u
  }

  before(:each) do
    sign_in user
  end

  describe "index" do

    it "uses the query object" do
      expect_any_instance_of(CollectionQuery).to receive(:for_curator).with(user)
      get :index
    end


    it "is a success" do
      get :index
      expect(response).to be_success
    end
  end

  describe "new" do

    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
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
  end


  describe "create" do
    before(:each) do
      allow(SaveCollection).to receive(:call).and_return(collection)
    end

    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
      post :create, params
    end

    it "calls the save service" do
      expect(SaveCollection).to receive(:call).and_return(collection)
      post :create, params
    end

    it "assigns a collection" do
      post :create, params

      assigns(:collection)
      expect(assigns(:collection)).to eq(collection)
    end

    it "redirects on success" do
      allow(SaveCollection).to receive(:call).and_return(collection)

      post :create, params
      expect(response).to be_redirect
    end

    it "renders new on failure" do
      allow(SaveCollection).to receive(:call).and_return(invalid_collection)

      post :create, params
      expect(response).to render_template(:new)
    end
  end


  describe "edit" do
    before(:each) do
      allow_any_instance_of(CollectionQuery).to receive(:find).and_return(collection)
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
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
  end
end
