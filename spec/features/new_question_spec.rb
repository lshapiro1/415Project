require 'rails_helper'

RSpec.feature "NewQuestions", type: :feature do
  include Devise::Test::IntegrationHelpers

  describe "create a new question" do
    before (:each) do
      admin = FactoryBot.create(:admin)
      sign_in admin
      @c = FactoryBot.create(:course)
    end

    it "should fail if qname isn't included" do
      visit course_questions_path(@c)
      click_on "Create a new question"
      click_on "Create question"
      expect(page.current_path).to eq(new_course_question_path(@c))
      expect(page.text).to match(/qname can't be blank/i)
    end

    it "should fail for multichoice question if qcontent isn't included" do
      visit course_questions_path(@c)
      click_on "Create a new question"
      fill_in "question_qname", :with => "A new question"
      select "MultiChoiceQuestion", from: "question_type"
      click_on "Create question"
      expect(page.current_path).to eq(new_course_question_path(@c))
      expect(page.text).to match(/qcontent missing newline-separated options for multichoice question/i)
    end

    it "should succeed if qname is included for numeric/free response" do
      visit course_questions_path(@c)
      click_on "Create a new question"
      fill_in "question_qname", :with => "NEWQ"
      select "NumericQuestion", from: "question_type"
      click_on "Create question"
      expect(page.current_path).to eq(course_questions_path(@c))
      expect(page.text).to match(/NEWQ/)
    end

    it "should succeed if both qname and qcontent are included for multichoice" do
      visit course_questions_path(@c)
      click_on "Create a new question"
      fill_in "question_qname", :with => "NEWQ"
      fill_in "question_qcontent", :with => "a\nb\nc"
      select "MultiChoiceQuestion", from: "question_type"
      click_on "Create question"
      expect(page.current_path).to eq(course_questions_path(@c))
      expect(page.text).to match(/NEWQ/)
    end
  end
end
