FactoryBot.define do

  sequence :opt do |i|
    "Option #{i}"
  end

  factory :multi_choice_option do
    value { generate(:opt) }
    question
  end

  factory :free_response_question do
    question { "Gimme a free response" }
  end

  factory :numeric_question do
    question { "Gimme a number" }
  end

  factory :question do
    qname { "Select an option" }
    type { "multi_choice_question" }
    transient do
      option_count { 4 }
    end
    course

    after(:create) do |question, evaluator|
      create_list(:multi_choice_option,  evaluator.option_count, question: question)
    end
  end

  factory :poll do
    question
  end
end
