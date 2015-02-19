require "rails_helper"

RSpec.describe CollectionsController, :type => :controller do
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }
  let(:collections) { [collection] }
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

    it ""
  end

end
