require 'rails'

describe SitePermission do
  subject { described_class.new(user, controller) }
  let(:user) { double(User) }
  let(:controller) { ApplicationController.new }
  let(:collection) { double(Collection) }

  it 'returns true when user is administrator' do
    expect(UserIsAdmin).to receive(:call).with(user).and_return(true)
    expect(subject.user_is_administrator?).to be(true)
  end

  it 'returns false when user is not an administrator' do
    expect(UserIsAdmin).to receive(:call).with(user).and_return(false)
    expect(subject.user_is_administrator?).to be(false)
  end

  it 'returns true if the masqing users is an admin ' do
    expect(UserIsAdmin).to receive(:call).with(user).and_return(true)
    allow_any_instance_of(Masquerade).to receive(:masquerading?).and_return(true)
    allow_any_instance_of(Masquerade).to receive(:user).and_return(user)
    expect(subject.user_is_administrator?).to be(true)
  end

  it 'returns false if the user is not masquerading' do
    expect(UserIsAdmin).to receive(:call).with(user).and_return(false)
    allow_any_instance_of(Masquerade).to receive(:masquerading?).and_return(false)
    allow_any_instance_of(Masquerade).to receive(:user).and_return(false)
    expect(subject.user_is_administrator?).to be(false)
  end

  it 'returns true when a user is a editor' do
    expect(UserIsEditor).to receive(:call).with(user, collection).and_return(true)
    expect(subject.user_is_editor?(collection)).to be(true)
  end

  it 'returns false when a user is not a editor' do
    expect(UserIsEditor).to receive(:call).with(user, collection).and_return(false)
    expect(subject.user_is_editor?(collection)).to be(false)
  end
end
