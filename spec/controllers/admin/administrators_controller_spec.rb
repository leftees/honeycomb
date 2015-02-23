require "rails_helper"

RSpec.describe Admin::AdministratorsController, :type => :controller do

  before(:each) do
    sign_in_admin
  end

  describe "GET #index" do
    subject { get :index }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("index")
    end

    it "checks the admin permissions" do
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
      subject
    end

    it "users the administrator query to get the list" do
      expect_any_instance_of(AdministratorQuery).to receive(:list)
      subject
    end
  end

  describe "#create" do
    let(:user) { instance_double(User, username: 'netid') }

    it 'calls SetAdminOnUser with the user' do
      expect(FindOrCreateUser).to receive(:call).with(user.username).and_return(user)
      expect(SetAdminOnUser).to receive(:call).with(user).and_return(true)
      expect_any_instance_of(Admin::AdministratorDecorator).to receive(:to_hash).and_return({test: :test})
      post :create, user: {username: user.username}
      expect(response).to be_success
      expect(response.body).to eq({test: :test}.to_json)
    end

    it 'errors if the user is not found' do
      expect(FindOrCreateUser).to receive(:call).with(user.username).and_return(false)
      post :create, user: {username: user.username}, collection_id: 1
      expect(response).to be_error
    end
  end

  describe 'GET #user_search' do
    let(:query) { 'test' }
    let(:test_results) { [{id: "fake1", label: "Robert Franklin", value: "Robert Franklin"}] }

    describe 'stubbed search' do
      before do
        allow(PersonAPISearch).to receive(:call).and_return([])
      end

      it "checks the admin permissions" do
        expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!)
        get :user_search, q: query
        expect(response).to be_success
      end
    end

    it "renders the json results from PersonAPISearch" do
      expect(PersonAPISearch).to receive(:call).with(query).and_return(test_results)
      get :user_search, q: query
      expect(response).to be_success
      expect(response.body).to eq(test_results.to_json)
    end
  end
end
