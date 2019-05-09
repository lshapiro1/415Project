FactoryBot.define do

  factory :multi_choice_question do
    question { "What is the answer?" }
    transient do
      option_count { 4 }
    end
    course

    after(:create) do |question, evaluator|
      create_list(:option,  evaluator.option_count, question: question)
    end
  end

  factory :poll do
    multi_choice_question
  end
end
