class ApplicationController < ActionController::Base
  before_action :authenticate_user!

protected
  def student_redirect
    redirect_to courses_path if current_user.student?
  end
end
