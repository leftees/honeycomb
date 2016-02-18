
describe MetadataValidator do
  let(:metadata) { double(errors: errors) }
  let(:errors) { double({}) }
  let(:error) { double }
  let(:configuration) { double(Metadata::Configuration, fields: [field]) }

  let(:empty_value) { double(empty?: true, nil?: false) }
  let(:nil_value) { double(empty?: false, nil?: true) }
  let(:present_value) { double(empty?: false, nil?: false) }

  subject { MetadataValidator.new.validate(metadata) }

  before(:each) do
    allow_any_instance_of(described_class).to receive(:configuration).and_return(configuration)
  end

  context "required_field" do
    let(:field) { double(required: true, name: :field) }

    it "adds an error if the field is empty?" do
      allow(metadata).to receive(:field).and_return(empty_value)
      expect(metadata.errors).to receive(:[]).with(field.name).and_return(error)
      expect(error).to receive("<<").with("is required")

      subject
    end

    it "adds an error if the field is nil?" do
      allow(metadata).to receive(:field).and_return(nil_value)
      expect(metadata.errors).to receive(:[]).with(field.name).and_return(error)
      expect(error).to receive("<<").with("is required")

      subject
    end

    it "does not add an error when the field has value " do
      allow(metadata).to receive(:field).and_return(present_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end
  end

  context "not required_field" do
    let(:field) { double(required: false, name: :field) }

    it "adds an error if the field is empty?" do
      allow(metadata).to receive(:field).and_return(empty_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end

    it "adds an error if the field is nil?" do
      allow(metadata).to receive(:field).and_return(nil_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end

    it "does not add an error when the field has value " do
      allow(metadata).to receive(:field).and_return(present_value)
      expect(metadata.errors).to_not receive(:[]).with(field.name)

      subject
    end
  end
end
