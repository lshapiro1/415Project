class QuestionsController < ApplicationController
  before_action :redirect_if_student

  def index
    @course = Course.find(params[:course_id])    
    @questions = course.questions.order(:type)
  end
end
