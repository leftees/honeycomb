require 'rails_helper'

RSpec.describe CollectionLeftNav do
  subject { described_class.new(collection)}
  let(:collection) { double(Collection, id:  1) }

  it "renders the correct template" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/collection_left_nav", locals: { nav: subject }})
    subject.display
  end


end
