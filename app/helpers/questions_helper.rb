module QuestionsHelper
  def question_type(t)
    t =~ /^(\w+)Question$/ 
    $1.downcase
  end

  def question_types
    %w{MultiChoiceQuestion NumericQuestion FreeResponseQuestion}
  end

  def question_input(q)
    case q.type
      when "MultiChoiceQuestion"
        q.qcontent.each do |opt|
          radio_button_tag :response, opt
        end
      when "NumericQuestion"
        number_field_tag :response, :step => 0.01 
      when "FreeResponseQuestion"
        text_field_tag :response
    end
  end
end
