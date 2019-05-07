require 'rails_helper'

RSpec.feature "CourseIndices", type: :feature do
  describe "course index page" do
    it "should list courses that exist" do
      Course.create!(:name => "One", :daytime => "TR 8:30-9:55")
      Course.create!(:name => "Two", :daytime => "MWF 10:20-11:10")

      visit courses_path
      expect(page).to contain("One")
      expect(page).to contain("Two")
    end
  end
end
