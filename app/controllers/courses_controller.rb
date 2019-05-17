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
      if @poll
        @response = @poll.new_response
        @current = PollResponse.where(:poll => @poll, :user => current_user).first
      end
      render 'show_student'
    else
      redirect_to course_questions_path(@course) and return
    end
  end

  def create_and_activate
    course = params[:c]
    question = params[:q]
    numopts = params[:n].to_i
    t = params[:t] || 'm' # m, n, f
    @course = Course.where(:name => course).first
    if !@course
      flash[:notice] = "Course #{course} doesn't exist"
      redirect_to courses_path and return
    end

    qtypes = {'m': MultiChoiceQuestion, 'n': NumericQuestion, 'f': FreeResponseQuestion }
    qt = qtypes[t]
    if qt.nil?
      flash[:notice] = "Question type #{params[:t]} doesn't exist"
      redirect_to course_path(@course) and return
    end

    @question = qt.send(:new)
    @question.qname = question
    if t == 'm'
      @question.qcontent = alpha.split(//)[0...numopts]
    end
    @course.questions << @question
    if !@question.save
      flash[:alert] = "Failed to save question #{question}"
      redirect_to course_questions_path(@course) and return
    end

    # close all other polls
    Poll.closeall(@course)
    num = @question.polls.maximum(:round).to_i
    @poll = @question.new_poll
    @poll.isopen = true
    @poll.round = num + 1
    if !@poll.save
      flash[:alert] = "Failed to save poll for question #{question}"
      redirect_to course_question_path(@course, @question) and return
    end

    flash[:notice] = "Started new poll"
    redirect_to course_question_poll_path(@course, @question, @poll) and return
   # http://localhost:3000/x?q=What%20will%20these%20rules%20do?&c=COSC101S19&n=4`
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
