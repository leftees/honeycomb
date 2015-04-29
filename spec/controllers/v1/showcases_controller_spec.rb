require 'rails_helper'
require "cache_spec_helper"

RSpec.describe V1::ShowcasesController, type: :controller do
  let(:collection) { instance_double(Collection, id: "1", updated_at: nil, showcases: nil) }
  let(:showcase) { instance_double(Showcase, id: "1", updated_at: nil, sections: nil, items: nil, collection: nil) }

  before(:each) do
    allow_any_instance_of(ShowcaseQuery).to receive(:public_find).and_return(showcase)
    allow_any_instance_of(CollectionQuery).to receive(:public_find).and_return(collection)
  end

  describe '#index' do
    subject { get :index, collection_id: collection.id, format: :json }
    it 'calls CollectionQuery' do
      expect_any_instance_of(CollectionQuery).to receive(:public_find).with(collection.id).and_return(collection)

      subject
    end

    it 'is successful' do
      subject

      expect(response).to be_success
      expect(assigns(:collection)).to be_present
      expect(subject).to render_template('v1/showcases/index')
    end

    it_behaves_like "a private basic custom etag cacher"
  end

  describe '#show' do
    subject { get :show, id: 'id', format: :json }
    it 'calls ShowcaseQuery' do
      expect_any_instance_of(ShowcaseQuery).to receive(:public_find).with('id').and_return(showcase)

      subject
    end

    it 'is successful' do
      subject

      expect(response).to be_success
      expect(assigns(:showcase)).to be_present
      expect(subject).to render_template('v1/showcases/show')
    end

    it_behaves_like "a private basic custom etag cacher"
  end
end
