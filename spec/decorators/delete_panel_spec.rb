require "rails_helper"

RSpec.describe DeletePanel do
  subject { described_class.new(object) }
  let(:object) { Object.new }

  it "renders the delete section template" do
    # removed because it errors in a strange way
    required_locals = { default_name: "Object", path: object, i18n_key_base: "objects.delete_panel", can_delete: true }
    expect(subject.h).to receive(:render).with(partial: "shared/delete_panel", locals: required_locals)
    subject.display
  end

  it "allows delete by default" do
    required_locals = { default_name: "Object", path: object, i18n_key_base: "objects.delete_panel", can_delete: true }
    expect(subject.h).to receive(:render).with(partial: "shared/delete_panel", locals: required_locals)
    subject.display
  end

  it "uses a custom query object to check if it can be deleted" do
    expect(object).to receive(:can_delete?).and_return(false)
    required_locals = { default_name: "Object", path: object, i18n_key_base: "objects.delete_panel", can_delete: false }
    allow(subject.h).to receive(:render).with(partial: "shared/delete_panel", locals: required_locals)
    subject.display(object)
  end

  it "allows the path to be set" do
    subject.display do |ds|
      ds.path = "/path"
    end

    expect(subject.path).to eq("/path")
  end
end
