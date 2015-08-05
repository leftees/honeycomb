require "rails_helper"

RSpec.describe DisplayFlashMessage do
  subject { described_class.new(flash) }
  let(:flash) { {} }

  described_class::KEY_2_CSS_CLASS.each do |key, css_class|
    it "displays the flash messages for notices" do
      flash[key] = "flash"
      result = "<div data-react-class=\"PageMessage\" data-react-props=\"{&quot;messageText&quot;:&quot;flash&quot;,&quot;css_class&quot;:&quot;#{css_class}&quot;}\"></div>"
      expect(subject.display).to eq(result)
    end
  end
end
