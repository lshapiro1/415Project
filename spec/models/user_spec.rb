require 'rails_helper'

RSpec.describe User, type: :model do
  it "should disallow creation with no email" do
    expect{ User.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  describe "from_omniauth" do
    it "should return nil if email is nil" do
      o = double('oauth')
      d = double('data')
      expect(d).to receive(:[]).with("email") { nil }
      expect(o).to receive(:info) { d }
      expect(User.from_omniauth(o)).to be nil
    end

    it "should return nil if the email is there but user doesn't exist" do
      o = double('oauth')
      d = double('data')
      expect(d).to receive(:[]).with("email") { "jsommers@acm.org" }
      expect(o).to receive(:info) { d }
      expect(User.from_omniauth(o)).to be nil
    end

    it "should return the email address if the user exists" do
      u = User.create!(:email => "jsommers@acm.org")
      o = double('oauth')
      d = double('data')
      expect(d).to receive(:[]).with("email") { "jsommers@acm.org" }
      expect(o).to receive(:info) { d }
      expect(User.from_omniauth(o)).to eq(u)
    end
  end
end
