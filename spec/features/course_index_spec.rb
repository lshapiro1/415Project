require 'rails_helper'

RSpec.feature "CourseIndices", type: :feature do
  include Devise::Test::IntegrationHelpers

  describe "course index page" do
    it "should list courses that exist" do
      sign_in FactoryBot.create(:student)
      Course.create!(:name => "One", :daytime => "TR 8:30-9:55")
      Course.create!(:name => "Two", :daytime => "MWF 10:20-11:10")

      visit courses_path
      expect(page.text).to match(/student\d+@colgate.edu/)
      expect(page.text).to match(/One.+TR 8:30-9:55/)
      expect(page.text).to match(/Two.+MWF 10:20-11:10/)
    end

    it "should not allow student to visit course show page for courses not enrolled in" do
      sign_in FactoryBot.create(:student)
      c1 = Course.create!(:name => "One", :daytime => "TR 8:30-9:55")
      c2 = Course.create!(:name => "Two", :daytime => "MWF 10:20-11:10")

      visit course_path(c1)
      expect(page.current_path).to eq(courses_path)
      expect(page.text).to match(/not enrolled/)
    end

    it "should allow a student enrolled in a course to visit the show page" do
      u = FactoryBot.create(:student)
      sign_in u
      c1 = Course.create!(:name => "One", :daytime => "TR 8:30-9:55")
      c2 = Course.create!(:name => "Two", :daytime => "MWF 10:20-11:10")
      u.courses << c1
      u.courses << c2

      visit course_path(c1)
      expect(page.current_path).to eq(course_path(c1))
      expect(page.text).to match(/no current poll/i)

      visit course_path(c2)
      expect(page.current_path).to eq(course_path(c2))
      expect(page.text).to match(/no current poll/i)

      visit course_path(3)
      expect(page.current_path).to eq(courses_path)
    end

    it "should allow an admin to see course details" do
      admin = FactoryBot.create(:admin)
      sign_in admin
      p = FactoryBot.create(:poll)
      q = p.question
      c = q.course
      visit course_path(c)
      expect(page.text).to match(/students enrolled/i)
    end
  end
end