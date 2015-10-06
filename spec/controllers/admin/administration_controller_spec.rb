require "rails_helper"
require "cache_spec_helper"

RSpec.describe Admin::AdministrationController, type: :controller do
  let(:user) { instance_double(User, id: 100, username: "netid") }

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
      expect_any_instance_of(described_class).to receive(:check_admin_permission!)
      subject
    end

    it_behaves_like "a private content-based etag cacher" do
      subject { get :index, format: :html }
    end
  end
end
