class PollsController < ApplicationController
  before_action :redirect_if_student

  def index
    @course = Course.find(params[:course_id])
    @question = Question.find(params[:question_id])
    @polls = @question.polls
  end

  def create
    @course = Course.find(params[:course_id])
    @question = Question.find(params[:question_id])
    Poll.deactivate(@course)
    num = @question.polls.count
    @poll = @question.new_poll
    @poll.isopen = true
    @poll.round = num + 1
    if @poll.save
      flash[:notice] = "Poll started for #{@question.qname}"
      redirect_to course_question_poll_path(@course, @question, @poll)
    else
      flash[:warning] = "Failed to start poll for #{@question.qname}"
      redirect_to course_questions_path(@course)
    end
  end

  def update
    @course = Course.find(params[:course_id])
    @question = Question.find(params[:question_id])
    @poll = Poll.find(params[:id])
    @poll.update(:isopen => false)
    flash[:notice] = "Poll stopped for #{@question.name}"
    redirect_to course_question_poll_path(@course, @question, @poll)
  end

  def destroy
    @course = Course.find(params[:course_id])
    @question = Question.find(params[:question_id])
    @poll = Poll.find(params[:id])
    flash[:notice] = "Poll #{@poll.round} for #{@question.qname} destroyed"
    redirect_to course_question_polls_path(@course, @question)
  end
end
