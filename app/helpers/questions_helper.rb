module QuestionsHelper
  def question_type(t)
    t =~ /^(\w+)Question$/ 
    $1.downcase
  end

  def question_types
    %w{MultiChoiceQuestion NumericQuestion FreeResponseQuestion}
  end

  def question_input(q, f)
    case q.type
      when "MultiChoiceQuestion"
        q.qcontent.each do |opt|
          f.radio_button :response, opt
        end
      when "NumericQuestion"
        f.number_field :response, :step => 0.01 
      when "FreeResponseQuestion"
        f.text_field :response
    end
  end
end
