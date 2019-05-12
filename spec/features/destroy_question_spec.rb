require 'rails_helper' 
RSpec.feature "DestroyQuestions", type: :feature do
  include Devise::Test::IntegrationHelpers
  it "should successfully destroy" do
    admin = FactoryBot.create(:admin)
    sign_in admin
    c = FactoryBot.create(:course)
    visit course_questions_path(c)
    click_link "Create a new question"
    fill_in "question_qname", :with => "TEST"
    fill_in "question_qcontent", :with => "a\nb\nc"
    select "MultiChoiceQuestion", from: "question_type"
    click_on "Create question"
    expect(page.current_path).to eq(course_questions_path(c))
    expect(page.text).to match(/TEST/)
    click_link "destroy_TEST"
    expect(page.current_path).to eq(course_questions_path(c))
    expect(page.text).not_to match(/TEST/)
  end
end
