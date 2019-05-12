module QuestionsHelper
  def question_type(t)
    t =~ /^(\w+)Question$/ 
    $1.downcase
  end

  def question_types
    %w{MultiChoiceQuestion NumericQuestion FreeResponseQuestion}
  end
end
