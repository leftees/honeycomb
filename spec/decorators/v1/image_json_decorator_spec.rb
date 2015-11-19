require "rails_helper"

RSpec.describe V1::ImageJSONDecorator do
  subject { described_class.new(image) }
  let(:image) { instance_double(Image, image: paperclip_attachment) }
  let(:paperclip_attachment) { instance_double(Paperclip::Attachment, content_type: "image/jpeg", original_filename: "filename", name: "filename", url: "image_uri", width: 200, height: 100) }
  let(:json) { double(Jbuilder, name: nil, width: nil, height: nil, encodingFormat: nil, contentUrl: nil) }

  it "defines @context as schema.org" do
    expect(subject.at_context).to eq("http://schema.org")
  end

  it "defines @type as ImageObject" do
    expect(subject.at_type).to eq("ImageObject")
  end

  it "defines @id as the full url for the paperclip attachment" do
    expect(subject.at_id).to eq("http://test.host/image_uri")
  end

  it "defines name as the paperclip filename" do
    expect(image.image).to receive(:original_filename)
    subject.name
  end

  it "defines encoding_format as the paperclip content type" do
    expect(image.image).to receive(:content_type)
    subject.encoding_format
  end

  it "defines url as the full url for the paperclip attachment" do
    expect(subject.url).to eq("http://test.host/image_uri")
  end

  it "defines width as the width of the paperclip attachment with the px suffix" do
    expect(subject.width).to eq("200 px")
  end

  it "defines height as the height of the paperclip attachment with the px suffix" do
    expect(subject.height).to eq("100 px")
  end

  describe "#display" do
    before(:each) do
      allow(json).to receive(:set!)
      # Stubbing these out to return the params given to make it easier to
      # find out how the json set! calls are made within the private methods
      allow(subject).to receive(:width) { |params| params }
      allow(subject).to receive(:height) { |params| params }
      allow(subject).to receive(:url) { |params| params }
    end

    context "base image" do
      it "sets @context" do
        expect(json).to receive(:set!).with("@context", subject.at_context)
        subject.display(json: json)
      end

      it "sets @id, using the large style url" do
        expect(json).to receive(:set!).with("@id", style: :large)
        subject.display(json: json)
      end

      it "sets name" do
        expect(json).to receive(:name).with(subject.name)
        subject.display(json: json)
      end

      it "sets @type" do
        expect(json).to receive(:set!).with("@type", subject.at_type)
        subject.display(json: json)
      end

      it "sets width, using the large style width" do
        expect(json).to receive(:width).with(style: :large)
        subject.display(json: json)
      end

      it "sets height, using the large style height" do
        expect(json).to receive(:height).with(style: :large)
        subject.display(json: json)
      end

      it "sets encodingFormat" do
        expect(json).to receive(:encodingFormat).with(subject.encoding_format)
        subject.display(json: json)
      end

      it "sets contentUrl, using the large style url" do
        expect(json).to receive(:contentUrl).with(style: :large)
        subject.display(json: json)
      end
    end

    context "small style" do
      it "sets properties under thumbnail/small" do
        expect(json).to receive(:set!).with("thumbnail/small")
        subject.display(json: json)
      end

      it "sets @type" do
        expect(json).to receive(:set!).with("@type", subject.at_type)
        subject.display(json: json)
      end

      it "sets encodingFormat" do
        expect(json).to receive(:encodingFormat).with(subject.encoding_format)
        subject.display(json: json)
      end
      # 
      # it "sets width, using the small style width" do
      #   allow(json).to receive(:width)
      #   expect(json).to receive(:width).with(style: :small)
      #   subject.display(json: json)
      # end
      #
      # it "sets height, using the small style height" do
      #   allow(json).to receive(:height)
      #   expect(json).to receive(:height).with(style: :small)
      #   subject.display(json: json)
      # end
      #
      # it "sets contentUrl, using the small style url" do
      #   allow(json).to receive(:contentUrl)
      #   expect(json).to receive(:contentUrl).with(style: :small)
      #   subject.display(json: json)
      # end
    end
  end
end
