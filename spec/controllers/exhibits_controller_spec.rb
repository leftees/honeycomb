require "rails_helper"

RSpec.describe ExhibitsController, :type => :controller do

  let(:user) {
    u = User.new(username: 'jhartzler', admin: true)
    u.save!

    u
  }

  before(:each) do
    sign_in user
  end


  describe "show" do
    subject { get :show, id: "1" }
    it "redirects to the items page" do
      subject

      expect(response).to redirect_to exhibit_showcases_path("1")
    end
  end
end
