require "rails_helper"

RSpec.describe Waggle::Index::Item do
  let(:item_id) { "pig-in-mud" }
  let(:raw_data) { File.read(Rails.root.join("spec/fixtures/v1/items/#{item_id}.json")) }
  let(:data) { JSON.parse(raw_data).fetch("items") }
  let(:index_class) { Waggle::Item }
  let(:instance) { index_class.new(data) }
  let(:other_instance) do
    data = instance.data.clone
    data["id"] += "other"
    data["metadata"]["name"]["values"].first["value"] += " pig"
    index_class.new(data)
  end

  before :all do
    unstub_solr
  end

  after :all do
    stub_solr
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

  describe "search" do
    before :each do
      described_class.setup
    end

    before do
      Sunspot.remove_all(index_class)
      Sunspot.commit
    end

    after do
      Sunspot.remove_all(index_class)
      Sunspot.commit
    end

    shared_examples_for "a searchable field" do |field_name, field_type|
      before do
        allow(instance.metadata).to receive(:value).and_call_original
      end

      if field_type == :time
        it "searches #{field_name} as #{field_type}" do
          timestamp = Time.now - 1.day
          expect(instance.metadata).to receive(:value).with(field_name).and_return([timestamp])
          Sunspot.index(instance)
          Sunspot.commit

          search = Sunspot.search index_class do
            with(field_name).equal_to timestamp
          end

          expect(search.total).to eq(1)

          search = Sunspot.search index_class do
            with(field_name).greater_than timestamp
          end

          expect(search.total).to eq(0)
        end
      elsif field_type == :text
        it "searches #{field_name} as #{field_type}" do
          q = field_name

          expect(instance.metadata).to receive(:value).with(field_name).and_return([q])
          Sunspot.index(instance)
          Sunspot.commit

          search = Sunspot.search index_class do
            fulltext q
          end

          expect(search.total).to eq(1)

          expect(instance.metadata).to receive(:value).with(field_name).and_return(nil)
          Sunspot.index(instance)
          Sunspot.commit

          search = Sunspot.search index_class do
            fulltext q
          end

          expect(search.total).to eq(0)
        end
      else
        raise "unknown type #{field_type}"
      end
    end

    Metadata::Configuration.item_configuration.fields.each do |field|
      if field.type == :date
        it_behaves_like "a searchable field", field.name, :time, multiple: true
      else
        it_behaves_like "a searchable field", field.name, :text
      end
    end

    it "is searchable" do
      Sunspot.index(instance)
      Sunspot.index(other_instance)
      Sunspot.commit

      q = "pig"

      search = Sunspot.search index_class do
        fulltext q do
          boost_fields name: 3.0
          highlight :name
        end
      end

      # search.hits.each do |hit|
      #   stored_values = hit.instance_variable_get(:@stored_values)
      #   pp stored_values
      # end

      hit = search.hits.detect { |h| h.primary_key == instance.id }
      expect(hit.highlights.first).to be_kind_of(Sunspot::Search::Highlight)
      expect(hit.highlights.first.formatted).to eq("<em>pig</em>-in-mud")
      expect(hit.stored(:name)).to eq(["pig-in-mud"])
    end
  end
end
