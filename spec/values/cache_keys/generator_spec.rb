require "rails_helper"

RSpec.describe CacheKeys::Generator do
  let(:subject) { CacheKeys::Generator.new(key_generator: Class, action: "specificmethod", arg1: 1) }

  it "calls the chosen generator method" do
    expect_any_instance_of(Class).to receive(:specificmethod)
    subject.generate
  end

  it "passes any additional arguments to the chosen generator method" do
    expect_any_instance_of(Class).to receive(:specificmethod).with(arg1: 1)
    subject.generate
  end

  it "is the generator's return value" do
    allow_any_instance_of(Class).to receive(:specificmethod).and_return("one")
    expect(subject.generate).to eq("one")
  end
end
