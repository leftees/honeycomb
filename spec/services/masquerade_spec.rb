require "spec_helper"

describe Masquerade do
  before(:each) do
    @controller = double(ActionController, session: {}, current_user: double(User, id: 1))
    allow(@controller).to receive(:sign_in)
  end

  describe :start! do
    before(:each) do
      allow_any_instance_of(Masquerade).to receive(:find_or_create_user).and_return(double(User, username: "username", name: "bob bobbers"))
    end

    it "calls sign in on the controller" do
      expect(@controller).to receive(:sign_in)
      Masquerade.new(@controller).start!("username")
    end

    it "sets a session value so we can return to the original user" do
      Masquerade.new(@controller).start!("username")
      expect(@controller.session[:masquerading]).to eq(1)
    end

    it "sets the masqueading user correctly " do
      # this test and code exists becaues @controller.sign_in does not always return the new user's name on the first page load
      m = Masquerade.new(@controller)
      m.start!("username")

      expect(m.masquerading_user.name).to eq("bob bobbers")
    end
  end

  describe :stop! do
    before(:each) do
      @user = double(User, name: "Original User")
      allow_any_instance_of(Masquerade).to receive(:original_user).and_return(@user)
      allow_any_instance_of(Masquerade).to receive(:masquerading?).and_return(true)
    end

    it "calls sign in on the controller with the original user" do
      expect(@controller).to receive(:sign_in).with(@user)

      Masquerade.new(@controller).cancel!
    end

    it "empties the session out" do
      expect(@controller).to receive(:sign_in).with(@user)

      Masquerade.new(@controller).cancel!

      expect(@controller.session[:masquerading]).to be_falsy
    end
  end
end
