require "rails_helper"

RSpec.describe ExhibitsController, :type => :controller do
  let(:exhibit) { double(Exhibit, id: 1, title: 'title', collection: collection) }
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }

  let(:user) {
    u = User.new(username: 'jhartzler', admin: true)
    u.save!

    u
  }

  before(:each) do
    sign_in user

    allow_any_instance_of(ExhibitQuery).to receive(:find).and_return(exhibit)
  end

  describe "show" do
    subject { get :show, id: "1" }
    it "redirects to the items page" do
      subject

      expect(response).to redirect_to exhibit_showcases_path("1")
    end
  end

  describe "edit" do
    subject { get :edit, id: "1" }

    it "returns a 200" do
      subject

      expect(response).to be_success
      expect(response).to render_template("edit")
    end

    it "checks the curator permissions" do
      expect_any_instance_of(described_class).to receive(:check_user_curates!).with(collection)
      subject
    end

    it "users the item query to get items" do
      expect_any_instance_of(ExhibitQuery).to receive(:find).with("1").and_return(exhibit)
      subject
    end
  end
end
