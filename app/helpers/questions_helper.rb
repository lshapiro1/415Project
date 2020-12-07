module QuestionsHelper
  def attendance_taken?(course)
    attendq = course.questions.where(:type => "AttendanceQuestion").first
    return attendq.nil? ? false : attendq.attendance_taken?
  end

  def student_responses(q,user = current_user)
    rr = PollResponse.joins(:poll).where("polls.question_id" => q.id).where("poll_responses.user_id" => user).select(:response)
    if rr.length == 0
      "No responses"
    else
      out = rr.collect {|rec| rec.response}.join(',')
      "#{rr.length} response: #{out}"
    end
  end

  def question_type(t)
    t =~ /^(\w+)Question$/ 
    $1.capitalize
  end

  def question_icon(t)
    t =~ /^(\w+)Question$/ 
    t = $1.downcase.to_sym
    icons = {'multichoice': 'list-ordered', 'numeric': 'graph', 'freeresponse': 'quote'}
    icons[t]
  end

  def question_types
    %w{MultiChoiceQuestion NumericQuestion FreeResponseQuestion}
  end

  def question_input(q, currresponse)
    curr = currresponse ? currresponse.response : ""
    case q.type
      when "MultiChoiceQuestion"
        s = ""
        q.qcontent.each do |opt|
          h = {:class => "form-check-input"}
          # FIXME: doesn't work
          if opt==curr 
            h[:checked]='checked'
          end
          t = radio_button_tag('response', opt, **h)
          t += label_tag(opt)
          s = s + "<div class='form-check'>" + t + "</div>"
        end
        s.html_safe
      when "NumericQuestion"
        number_field_tag :response, curr, :step => 0.01, :class => "form-control"
      when "FreeResponseQuestion"
        text_field_tag :response, curr, :class => "form-control"
    end
  end

  def show_image(img)
    if img.attached?
      image_tag(img.variant(resize: "100x100^")).html_safe
    end
  end
  
  def questionsByDate(course, user = current_user)
    questionHash = course.getQuestionsByDate
    sortedKeys = questionHash.keys.sort_by{|date| m,d,y = date.split('-'); [y,m,d] }
    return getDateInfo(sortedKeys,questionHash, user)
  end
  
  def getDateInfo(dates,questionsHash, user = current_user)
    toReturn = Array.new
    dates.each do |d|
      correct = 0
      incorrect = 0
      questionsHash[d].each do |q|
        if !q.active_poll
          rr = PollResponse.joins(:poll).where("polls.question_id" => q.id).where("poll_responses.user_id" => user).select(:response)
          if rr.length != 0
            rr.each do |ans|
              if (ans == q.answer)
                correct+= 1
              else
                incorrect += 1
              end
            end
          end
        end
      end
      toReturn << [d,questionsHash[d].length, correct, incorrect,questionsHash[d]]
    end
    return toReturn
  end
  
end
