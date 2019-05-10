class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    @course = Course.find(params[:id])
    if current_user.student? 
      if !current_user.courses.include? @course
        flash[:notice] = "You're not enrolled in #{@course.name}"
        redirect_to courses_path and return
      end
      render 'show_student'
    else
      render 'show_admin'        
    end
  end
end
