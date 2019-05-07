FactoryBot.define do

  factory :multi_choice_question do
    question { "What is the answer?" }
    sequence :option { |n| "Option #{n}" }
  end
end
