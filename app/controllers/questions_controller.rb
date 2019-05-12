class QuestionsController < ApplicationController
  before_action :redirect_if_student

  def index
    @course = Course.find(params[:course_id])    
    @questions = @course.questions.order(:type)
  end

  def new
    @course = Course.find(params[:course_id])    
    @q = Question.new
  end

  def create
    @course = Course.find(params[:course_id])    
    @q = @course.questions.create(create_params)
    if @q
      redirect_to course_questions_path(@course) and return
    else
      msg = @q.errors.full_messages.join('; ')
      flash[:warning] = "No question created: #{msg}"
      redirect_to new_course_question_path(@course) and return
    end
  end

private
  def create_params
    params.require(:question).permit(:qname, :type, :qcontent, :content_type)
  end
end
