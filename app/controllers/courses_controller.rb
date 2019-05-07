class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def show
    begin
      @course = Course.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      flash[:warning] = "Invalid course"
      redirect_to courses_path and return
    end
  end
end
