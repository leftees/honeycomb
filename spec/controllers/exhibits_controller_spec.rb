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

end
