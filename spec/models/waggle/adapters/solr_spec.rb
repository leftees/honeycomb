RSpec.describe Waggle::Adapters::Solr do
  let(:session) { instance_double(Waggle::Adapters::Solr::Session) }

  describe "session" do
    subject { described_class.session }

    it "is a Session" do
      expect(subject).to be_kind_of(Waggle::Adapters::Solr::Session)
    end
  end

  context "stubbed session" do
    before do
      allow(described_class).to receive(:session).and_return(session)
    end

    context "indexing" do
      let(:instances) { [instance_double(Waggle::Item), instance_double(Waggle::Item)] }

      describe "index" do
        subject { described_class.index(instances) }

        it "calls index on the session" do
          expect(session).to receive(:index).with(instances)
          subject
        end
      end

      describe "index!" do
        subject { described_class.index!(instances) }

        it "calls index! on the session" do
          expect(session).to receive(:index!).with(instances)
          subject
        end
      end

      describe "remove" do
        subject { described_class.remove(instances) }

        it "calls remove on session" do
          expect(session).to receive(:remove).with(instances)
          subject
        end
      end

      describe "remove!" do
        subject { described_class.remove!(instances) }

        it "calls remove! on session" do
          expect(session).to receive(:remove!).with(instances)
          subject
        end
      end
    end

    describe "commit" do
      subject { described_class.commit }

      it "calls commit on the session" do
        expect(session).to receive(:commit)
        subject
      end
    end
  end

  describe "search_result" do
    let(:query) { instance_double(Waggle::Search::Query) }
    subject { described_class.search_result(query) }

    it "returns a new search result" do
      expect(described_class::Search::Result).to receive(:new).with(query).and_return("result")
      expect(subject).to eq("result")
    end
  end
end
