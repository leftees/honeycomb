require 'rails_helper'

RSpec.describe Nav::CollectionLeft do
  subject { described_class.new(collection)}
  let(:collection) { double(Collection, id:  1, title: 'Title', exhibit: exhibit) }
  let(:exhibit) { double(Exhibit, id: 1)}

  it "renders the correct template" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/collection_left_nav", locals: { nav: subject }})
    subject.display(:section)
  end

  it "returns the object as collection" do
    expect(subject.collection).to eq(collection)
  end

  it "sets selected when the left nav section is active" do
    subject.display(:section)
    expect(subject.active_section_css(:section)).to eq("selected")
  end

  it "sets empty when the left nav section is not active" do
    subject.display(:section)
    expect(subject.active_section_css(:other_section)).to eq("")
  end

end
