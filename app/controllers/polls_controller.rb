class PollsController < ApplicationController
  before_action :redirect_if_student

  def index
    @course = Course.find(params[:course_id])
    @question = Question.find(params[:question_id])
    @polls = @question.polls
  end
end
