require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    it "redirects to login for an unauthenticated user" do
      get :index, :params => {:course_id => 1 }
      expect(response).to redirect_to(user_session_path)
    end

    it "returns http success for an admin" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)      
      get :index, :params => {:course_id => c.id}
      expect(response).to have_http_status(:success)
    end

    it "redirects to course index for an invalid course id" do
      sign_in FactoryBot.create(:admin)
      get :index, :params => {:course_id => 1000 }
      expect(response).to redirect_to(courses_path)
    end

    it "redirects to course index for a student" do
      s = FactoryBot.create(:student)
      sign_in s
      c = FactoryBot.create(:course)
      get :index, :params => {:course_id => c.id}
      expect(response).to redirect_to(courses_path)
    end
  end
  
  describe "GET #show" do
    it "returns http success" do
      s = FactoryBot.create(:student)
      sign_in s
      c = FactoryBot.create(:course)  
      q = Question.create(:course => c, :qname => "question", :type => "NumericQuestion")
      get :show, :params => {:course_id => c.id, :id => q.id}
      expect(response).to have_http_status(:success)
    end
    
  end

  describe "GET #new" do
    it "returns http success for an admin" do
      s = FactoryBot.create(:admin)
      sign_in s
      c = FactoryBot.create(:course)      
      get :index, :params => {:course_id => c.id}
      expect(response).to have_http_status(:success)
    end
  end

  describe "POST #create" do
    it "redirects to new on failure" do
      a = FactoryBot.create(:admin)
      sign_in a
      c = FactoryBot.create(:course)      
      post :create, :params => {:course_id => c.id, :question => {:qname => "", :qcontent => "", :type => "MultiChoiceQuestion" }}
      expect(response).to redirect_to(new_course_question_path(c))
    end
  end

  describe "DELETE #destroy" do
    it "should delete successfully for valid ids" do
      sign_in FactoryBot.create(:admin)
      c = FactoryBot.create(:course)      
      q = Question.create(:course => c, :qname => "question", :type => "NumericQuestion")
      delete :destroy, :params => {:course_id => c.id, :id => q.id}
      expect(response).to redirect_to(course_questions_path(c))
    end
  end
end
