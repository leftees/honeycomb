require 'rails_helper'

describe ExhibitQuery do
  subject {described_class.new(relation)}
  let(:relation) { Exhibit.all }

  context "all_for_user" do
    let(:user) { double }

    it "returns all the exhibits for a given user"

    it "temporarily returns all exhibits" do
      expect(relation).to receive(:all).and_call_original
      subject.all_for_user(user)
    end

  end

end
