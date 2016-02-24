require "rails"

describe CollectionConfigurationQuery do
  subject { described_class.new(collection) }
  let(:collection) { double(Collection, collection_configuration: collection_configuration) }
  let(:collection_configuration) { double }

  it "passes the current collection's config to the Metadata::Configuration" do
    expect(Metadata::Configuration).to receive(:new).with(collection_configuration)
    subject.find
  end

  describe "max_metadata_order" do
    let(:fields) { [] }
    let(:configuration) { instance_double(Metadata::Configuration, fields: fields)}

    before (:each) do
      allow(subject).to receive(:find).and_return(configuration)
    end


    context "when there are no records" do
      let(:fields) { [] }

      it "returns 0" do
        expect(subject.max_metadata_order).to eq(0)
      end
    end

    context "when there is only one record" do
      let(:fields) { [instance_double(Metadata::Configuration::Field, order: 100)] }

      it "returns order of that record" do
        expect(subject.max_metadata_order).to eq(fields[0].order)
      end
    end

    context "when there are multiple records sorted by order" do
      let(:fields) do
        [
          instance_double(Metadata::Configuration::Field, order: 1),
          instance_double(Metadata::Configuration::Field, order: 2),
          instance_double(Metadata::Configuration::Field, order: 3)
        ]
      end

      it "returns max order within those records" do
        expect(subject.max_metadata_order).to eq(3)
      end
    end

    context "when there are multiple records sorted desc by order" do
      let(:fields) do
        [
          instance_double(Metadata::Configuration::Field, order: 3),
          instance_double(Metadata::Configuration::Field, order: 2),
          instance_double(Metadata::Configuration::Field, order: 1)
        ]
      end

      it "returns max order within those records" do
        expect(subject.max_metadata_order).to eq(3)
      end
    end

    context "when there are multiple records unsorted by order" do
      let(:fields) do
        [
          instance_double(Metadata::Configuration::Field, order: 0),
          instance_double(Metadata::Configuration::Field, order: 3),
          instance_double(Metadata::Configuration::Field, order: 1),
          instance_double(Metadata::Configuration::Field, order: 2)
        ]
      end

      it "returns max order within those records" do
        expect(subject.max_metadata_order).to eq(3)
      end
    end

    context "when there is a null value" do
      let(:fields) do
        [
          instance_double(Metadata::Configuration::Field, order: 0),
          instance_double(Metadata::Configuration::Field, order: nil),
          instance_double(Metadata::Configuration::Field, order: 2)
        ]
      end

      # Order is not based on user input, so we should never have nil
      it "throws an error" do
        expect{ subject.max_metadata_order }.to raise_error
      end
    end
  end
end
