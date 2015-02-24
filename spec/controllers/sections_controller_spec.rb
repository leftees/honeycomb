require "rails_helper"

RSpec.describe SectionsController, :type => :controller do
  let(:showcase) { double(Showcase, id: 1, title: 'title', destroy!: true, sections: relation, exhibit: exhibit) }
  let(:exhibit) { double(Exhibit, id: 1, title: 'title', showcases: relation, collection: collection) }
  let(:collection) { instance_double(Collection, id: 1, title: 'title') }

  let(:relation) { Section.all }
  let(:create_params) { {exhibit_id: exhibit.id, showcase: { title: 'title' }} }
  let(:update_params) { {id: showcase.id, item: { title: 'title' }} }

  before(:each) do
    sign_in_admin

    allow_any_instance_of(ShowcaseQuery).to receive(:find).and_return(showcase)
  end

  describe "GET #index" do
    subject { get :index, showcase_id: showcase.id }

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
      expect_any_instance_of(SectionQuery).to receive(:all_in_showcase)
      subject
    end

    it "assigns an item decorator to items" do
      subject
      assigns(:sections)
      expect(assigns(:sections)).to be_a(ShowcaseList)
    end
  end




end
