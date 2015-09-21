require "rails_helper"

RSpec.describe Waggle::Adapters::Sunspot::Index::Item do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:index_class) { described_class.index_class }
  let(:instance) { index_class.new(data) }
  let(:other_instance) do
    data = instance.data.clone
    data["id"] += "other"
    data["metadata"]["name"]["values"].first["value"] += " pig"
    index_class.new(data)
  end

  describe "self.index_class" do
    it "is Waggle::Item" do
      expect(described_class.index_class).to eq(Waggle::Item)
      expect(index_class).to eq(described_class.index_class)
    end
  end

  describe "self.setup" do
    subject { described_class.setup }

    it "calls reset!" do
      expect(described_class).to receive(:reset!)
      subject
    end

    it "sets up Sunspot for Waggle::Item" do
      described_class.reset!
      expect(Sunspot::Setup.for(index_class)).to be_nil
      subject
      expect(Sunspot::Setup.for(index_class)).to be_kind_of(Sunspot::Setup)
    end

    describe "fields" do
      before do
        allow_any_instance_of(Sunspot::DSL::Fields).to receive(:text)
        allow_any_instance_of(Sunspot::DSL::Fields).to receive(:time)
        allow_any_instance_of(Sunspot::DSL::Fields).to receive(:string)
      end

      shared_examples_for "a field indexer" do |field_name, field_type, arguments|
        it "indexes #{field_name} as #{field_type} with arguments: #{arguments}" do
          if arguments
            expect_any_instance_of(Sunspot::DSL::Fields).to receive(field_type).with(field_name, arguments)
          else
            expect_any_instance_of(Sunspot::DSL::Fields).to receive(field_type).with(field_name)
          end
          subject
        end
      end

      it_behaves_like "a field indexer", :name, :text, stored: true

      it_behaves_like "a field indexer", :unique_id, :string, stored: true

      it_behaves_like "a field indexer", :at_id, :string, stored: true

      it_behaves_like "a field indexer", :collection_id, :string, stored: true

      it_behaves_like "a field indexer", :type, :string, stored: true

      it_behaves_like "a field indexer", :thumbnail_url, :string, stored: true

      it_behaves_like "a field indexer", :last_updated, :time, stored: true

      context "metadata fields" do
        Metadata::Configuration.item_configuration.fields.each do |field|
          if field.type == :date
            it_behaves_like "a field indexer", field.name, :time, multiple: true
          else
            it_behaves_like "a field indexer", field.name, :text
          end
        end

        it "raises an error with an unexpected type" do
          allow(Metadata::Configuration.item_configuration.fields.first).to receive(:type).and_return(:fake_type)
          expect { subject }.to raise_error("unknown type fake_type")
        end
      end
    end
  end

  describe "self.reset!" do
    subject { described_class.reset! }

    it "resets an existing setup" do
      described_class.setup
      expect(Sunspot::Setup.for(index_class)).to be_kind_of(Sunspot::Setup)
      subject
      expect(Sunspot::Setup.for(index_class)).to be_nil
    end
  end
end
