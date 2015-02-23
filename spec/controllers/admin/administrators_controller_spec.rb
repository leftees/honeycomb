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
      expect_any_instance_of(described_class).to receive(:check_admin_or_admin_masquerading_permission!).with(collection)
      subject
    end

    it "users the administrator query to get the list" do
      expect_any_instance_of(AdministratorQuery).to receive(:list)
      subject
    end
  end
end
