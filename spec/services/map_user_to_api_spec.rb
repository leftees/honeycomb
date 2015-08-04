require "rails_helper"

describe MapUserToApi do
  subject { MapUserToApi.call(user) }
  let(:user) { double(User, username: "username", "first_name=" => true, "last_name=" => true, "display_name=" => true, "email=" => true) }
  let(:api_data) { { "first_name" => "first_name", "contact_information" => { "email" => "email" } } }

  before(:each) do
    remove_user_api_stub
    allow(HesburghAPI::PersonSearch).to receive(:find).and_return(api_data)
  end

  it "calls the api for the user data" do
    expect(HesburghAPI::PersonSearch).to receive(:find).with(user.username).and_return(api_data)

    subject
  end

  it "does not raise an exception if one is encountered and notifies via NotifyError" do
    expect(HesburghAPI::PersonSearch).to receive(:find).with(user.username).and_raise("error encountered")
    expect(NotifyError).to receive(:call).and_call_original
    subject
  end

  [:first_name, :last_name, :display_name].each do |field|
    it "sets the #{field} from the api data " do
      expect(user).to receive("#{field}=").with(api_data["#{field}"])
      subject
    end
  end

  it "sets the email" do
    expect(user).to receive("email=").with(api_data["contact_information"]["email"])
    subject
  end
end
