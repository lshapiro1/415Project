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
      c = Course.create!(:name => "One", :daytime => "MWF 9:20-10:10")
      expect(response).to have_http_status(:success)
      expect(assigns(:courses)).to eq([c])
    end
  end

  describe "GET #show" do
    it "redirects to login page for unauthenticated users" do
      get :show, :params => {:id => 1}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to("/users/sign_in")
    end
    
    it "doesn't redirect for signed in users" do
      sign_in FactoryBot.create(:user)
      c = Course.create!(:name => "One", :daytime => "MWF 9:20-10:10")
      get :show, :params => {:id => 1}
      expect(response).to have_http_status(:success)
      expect(assigns(:course)).to eq(c)
    end 

    it "should redirect to the course index for an invalid course id" do
      sign_in FactoryBot.create(:user)
      get :show, :params => {:id => 100}
      expect(response).to have_http_status(:redirect)
      expect(response).to redirect_to(courses_path)
    end
  end

end
