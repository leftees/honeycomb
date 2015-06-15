require "rails_helper"

RSpec.describe NotifyError do
  let(:exception) { instance_double(StandardError) }
  let(:args) { { test: "test" } }

  subject { described_class.new(exception: exception, args: args) }

  describe "self" do
    subject { described_class }

    describe "#call" do
      it "instantiates a new instance and calls #notify" do
        expect(subject).to receive(:new).with(exception: exception, args: args).and_call_original
        expect_any_instance_of(described_class).to receive(:notify)
        subject.call(exception: exception, args: args)
      end
    end
  end

  describe "#notify" do
    it "calls Airbrake#notify" do
      expect(Airbrake).to receive(:notify).with(exception, parameters: { args: args })
      subject.notify
    end
  end
end
