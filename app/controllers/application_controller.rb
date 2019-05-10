class ApplicationController < ActionController::Base
  before_action :authenticate_user!

protected
  def redirect_if_student
    redirect_to courses_path if current_user.student?
  end
end
