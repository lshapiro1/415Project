class CoursesController < ApplicationController
  before_action :go_to_current_course, :only => [:index]

  def index
    if current_user.admin?
      @courses = Course.all
    else
      @courses = current_user.courses
    end
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
        r = @poll.poll_responses.where(:user => current_user).first
        if @question.type == "AttendanceQuestion"
          if r
            flash[:notice] = "You already checked in! Wait until there is another question"
            redirect_to courses_path and return
          end
        end
        @response = @poll.new_response
        @current = PollResponse.where(:poll => @poll, :user => current_user).first
        @pid = @poll.id
        @qid = @question.id
        @qname = @question.qname
      else
        @pid = 0
        @qid = 0
        @qname = ""
      end
      @activepoll = !!@poll
      if @current != nil
        @answered = true
      else
        @answered = false
      end
      render'show_student'
    else
      redirect_to course_questions_path(@course) and return
    end
  end

  def take_attendance
    @course = Course.find(params[:course_id])
    @question = @course.questions.where(:type => "AttendanceQuestion").first
    if !@question
      @question = AttendanceQuestion.new
      @question.course = @course
      if !@question.save
        flash[:alert] = "Failed to save question #{@question}"
        redirect_to course_questions_path(@course) and return
      end
    end

    Poll.closeall(@course)
    num = @question.polls.maximum(:round).to_i
    @poll = @question.new_poll
    @poll.isopen = true
    @poll.round = num + 1
    if !@poll.save
      flash[:alert] = "Failed to save attendance poll"
      redirect_to course_question_path(@course, @question) and return
    end

    flash[:notice] = "Started new attendance poll"
    redirect_to course_question_poll_path(@course, @question, @poll) and return
  end

  def attendance_report
    @course = Course.find(params[:id])
    redirect_to course_path(@course) if current_user.student? 
    @apolls = Question.where(:type => "AttendanceQuestion", :course => @course).first.polls.order(:created_at)

    # Course.find(1).questions.where(:type => "AttendanceQuestion").joins(:polls).select("polls.id")

    @attendance_matrix = []  
    @apolls.each do |poll|
      thisrow = [ poll.created_at.strftime("%Y-%m-%d") ]
      @course.students.each do |s|
        thisrow << poll.poll_responses.where(:user_id => s.id).count
      end
      sum = thisrow[1..].sum
      thisrow << "#{sum} / #{thisrow.length-1}"
      @attendance_matrix << thisrow
    end
  end
  
  
  
  def question_report
    @course = Course.find(params[:id])
    redirect_to course_path(@course) if current_user.student? 

    pollids = @course.questions.where.not(:type => "AttendanceQuestion").joins(:polls).select("polls.id")

    @response_matrix = [] 
    @no_responses = true
    pollids.each do |pid|
      q = Poll.find(pid.id).question
      responseset = PollResponse.where(:poll_id => pid.id).joins(:user)
      if responseset.present?
        @no_responses = false
      end
      # thisrow = [ q.created_at.strftime("%Y-%m-%d"), q.id, pid.id, q.type[0] ]
      thisrow = [q.id, q.qname]
      count = 0
      total_correct = 0
      @course.students.each do |s|
        resp = responseset.where(:user_id => s.id).first 
        student_arr = []
        if resp
          count += 1
          if (q.answer)
            
            if(q.type == "NumericQuestion")
              student_resp = resp.response.round.to_s
            else
              student_resp = resp.response
            end
          
            if (q.answer == student_resp)
              # thisrow << "1"
              total_correct += 1.0
              student_arr = [s.email, student_resp,"✓"]
            else
              # thisrow << "0"
              student_arr = [s.email, student_resp, "X"]
              
            end
            
          else
            # thisrow << "!"
            student_arr = [s.email, student_resp, "NA"]
          end
        else
          student_arr = [s.email,"no response", "NA"]
        end
        thisrow << student_arr
      end
      thisrow << count
      thisrow << (total_correct / count) * 100.0
      @response_matrix << thisrow
    end
  end

  def status
    @course = Course.find(params[:id])
    logger.debug ("inside status")

    if !request.xhr?
      redirect_to course_path(params[:id]) and return
    end

    p = @course.active_poll     
    q = @course.active_question
    status_path = "/courses/#{@course.id}/questions/#{q ? q.id : 0}/polls/#{p ? p.id : 0}/status";

    status = if p.nil?
      status_path = "/courses/#{@course.id}"
      'closed'
    elsif p && !p.id.nil?
      'open'
    end
    render json: {'status': status, 'path': status_path }
  end

  def create_and_activate
    course = params[:c]
    question = params[:q]
    answer = params[:a]
    opts = params[:o]
    numopts = params[:n].to_i
    t = params[:t] || 'm' # m, n, f
    t = t.to_sym

    @course = Course.where(:name => course).first
    if !@course
      flash[:notice] = "Course #{course} doesn't exist"
      redirect_to courses_path and return
    end

    qtypes = {:m => MultiChoiceQuestion, :n => NumericQuestion, :f => FreeResponseQuestion }
    qt = qtypes[t]
    if qt.nil?
      flash[:notice] = "Question type #{params[:t]} doesn't exist"
      redirect_to course_path(@course) and return
    end

    if question.nil?
      flash[:notice] = "No question text given!"
      redirect_to course_path(@course) and return
    end

    @question = qt.send(:new)
    @question.answer = answer
    @question.qname = question
    if t == :m
      if opts
        @question.qcontent = opts
      else
        alpha = 'ABCDEFG'
        @question.qcontent = alpha.split(//)[0...numopts]
      end
    end
    @question.course = @course
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
    return if request.xhr?

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
