module QuestionsHelper
  def question_type(t)
    t =~ /^(\w+)Question$/ 
    $1.downcase
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
end
