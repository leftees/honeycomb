require 'rails_helper'

RSpec.describe CollectionUserListDecorator do
  let(:collection_user) { instance_double(CollectionUser)}
  subject{ described_class.new([collection_user])}

  describe '#curator_hashes' do
    it 'returns an array of hashes' do
      expect_any_instance_of(CollectionUserDecorator).to receive(:curator_hash).and_return({test: :test})
      result = subject.curator_hashes
      expect(result).to be_a_kind_of(Array)
      expect(result.first).to eq({test: :test})
    end
  end


end
