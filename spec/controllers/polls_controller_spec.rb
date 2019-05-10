require 'rails_helper'

RSpec.describe PollsController, type: :controller do
  include Devise::Test::ControllerHelpers
  
  describe "GET #index" do
    it "returns http success" do
      sign_in FactoryBot.create(:admin)
      poll = FactoryBot.create(:poll) 
      q = poll.question
      c = q.course
      get :index, :params => {:course_id => c.id, :question_id => q.id}
      expect(response).to have_http_status(:success)
    end
  end

end
