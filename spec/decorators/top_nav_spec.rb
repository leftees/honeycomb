require 'rails_helper'

RSpec.describe TopNav do
  subject { described_class.new(controller)}
  let(:controller) { double(current_user: nil_current_user) }
  let(:nil_current_user) { nil }
  let(:user) { double(User, display_name: 'DisplayName')}

  it "renders the footer template" do
    expect(subject.h).to receive(:render).with({:partial=>"shared/top_nav", locals: { nav: subject }})
    subject.display
  end


  it "determins the  display name from the current user" do
  	controller.stub(:current_user).and_return(user)
  	expect(subject.current_user_display_name).to eq("DisplayName")
  end

  it "determins the  display name from the current user if there is no current user" do
  	expect(subject.current_user_display_name).to eq("no user")
  end  
end
