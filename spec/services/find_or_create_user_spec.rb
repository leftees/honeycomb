require 'rails_helper'

describe FindOrCreateUser do
  subject { described_class }
  let(:username) { 'username' }
  let(:call) { described_class.call(username) }

  it 'returns a user when a user is found' do
    allow(User).to receive(:where).and_return([User.new(username: username)])
    expect(call).to be_kind_of(User)
  end

  it 'returns a user when a user is created' do
    allow(CreateUser).to receive(:call).and_return(User.new(username: username))
    expect(call).to be_kind_of(User)
  end

  subject { described_class.call(nil) }
  it 'returns a false when a user cannot be found or created' do
    expect_any_instance_of(FindOrCreateUser).to receive(:user).and_return(false)
    expect(call).to be(false)
  end
end
