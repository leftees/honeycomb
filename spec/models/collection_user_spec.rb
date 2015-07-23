require "rails_helper"

RSpec.describe CollectionUser do
  it "has a papertrail" do
    expect(subject).to respond_to(:paper_trail_enabled_for_model?)
    expect(subject.paper_trail_enabled_for_model?).to be(true)
  end
end
