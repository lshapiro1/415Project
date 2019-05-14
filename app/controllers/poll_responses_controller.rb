class PollResponsesController < ApplicationController
  def create
    # FIXME: verify that current_user is a student enrolled in @course
    # extract params and create new response or update existing response
    @course = Course.find(params[:course_id])
    @question = Question.find(params[:question_id])
    @polls = Poll.find(params[:id])

    byebug
  end
end
