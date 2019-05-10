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
end
