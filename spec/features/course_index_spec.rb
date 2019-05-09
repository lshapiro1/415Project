require 'rails_helper'

RSpec.feature "CourseIndices", type: :feature do
  include Devise::Test::IntegrationHelpers

  describe "course index page" do
    it "should list courses that exist" do
      sign_in FactoryBot.create(:user)
      Course.create!(:name => "One", :daytime => "TR 8:30-9:55")
      Course.create!(:name => "Two", :daytime => "MWF 10:20-11:10")

      visit courses_path
      expect(page.text).to match(/student\d+@colgate.edu/)
      expect(page.text).to match(/One.+TR 8:30-9:55/)
      expect(page.text).to match(/Two.+MWF 10:20-11:10/)
    end
  end
end
