require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe "GET #index" do
    it "redirects to login page for unauthenticated users" do
      get :index
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/users/sign_in")
    end
    
    it "doesn't redirect for signed in users" do
      sign_in FactoryBot.create(:user)
      get :index
      expect(response).to have_http_status(:success)
    end
  end

end
