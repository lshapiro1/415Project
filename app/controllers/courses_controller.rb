class CoursesController < ApplicationController
  before_action :go_to_current_course, :only => [:index]

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
      @poll = @course.active_poll
      @question = @course.active_question
      render 'show_student'
    else
      redirect_to course_questions_path(@course) and return
    end
  end

private
  def go_to_current_course
    cassoc = current_user.admin ? Course.all : current_user.courses
    cassoc.each do |c|
      # if course is going on now, then return show page path for redirect
      if c.now?
        redirect_to course_path(c) and return
      end
    end
    # fall-through on index if there's no specific course to redirect to
  end

end
