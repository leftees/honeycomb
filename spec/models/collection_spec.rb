require "rails_helper"

RSpec.describe Collection do
  [:title, :items, :description, :unique_id].each do | field |

    it "has field, #{field}" do
      expect(subject).to respond_to(field)
      expect(subject).to respond_to("#{field}=")
    end
  end

  it "requires the title field " do
    expect(subject).to have(1).error_on(:title)
  end

  it "requires a unique_id" do
    expect(subject).to have(1).error_on(:unique_id)
  end

  it "has paper trail" do
    expect(subject).to respond_to(:versions)
  end
end
