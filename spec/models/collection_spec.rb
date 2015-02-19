require "rails_helper"

RSpec.describe Collection do
  [:title, :items, :description].each do | field |

    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the title field " do
    expect(subject).to have(1).error_on(:title)
  end

  it "has paper trail" do
    expect(subject).to respond_to(:versions)
  end
end
