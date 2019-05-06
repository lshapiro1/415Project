require 'rails_helper'

RSpec.describe User, type: :model do
  it "should disallow creation with no email" do
      expect{ User.create! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end
