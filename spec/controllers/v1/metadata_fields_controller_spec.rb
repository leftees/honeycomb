require "rails_helper"
require "cache_spec_helper"

RSpec.describe V1::MetadataFieldsController, type: :controller do
  let(:collection) { instance_double(Collection, id: 1) }
  let(:collections) { [collection] }

  describe "update" do
    let(:params) { { name: "name" } }
    subject { put :update, collection_id: 1, field: params }

    it "calls to json on the V1::MetadataConfigurationJSON" do
      subject
    end
  end
end
