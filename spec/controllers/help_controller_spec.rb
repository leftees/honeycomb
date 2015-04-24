require 'rails_helper'
require "cache_spec_helper"

RSpec.describe HelpController, type: :controller do
  before(:each) do
    sign_in_user
  end

  describe 'get #help' do
    subject { get :help }

    it 'returns a 200' do
      subject

      expect(response).to be_success
      expect(response).to render_template('help')
    end

    it_behaves_like "a private content-based etag cacher"
  end
end
