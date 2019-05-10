FactoryBot.define do
  sequence :email do |i|
    "student#{i}@colgate.edu"
  end

  factory :user, aliases: [:student] do
    email { generate(:email) }
    password { "password"} 
    admin { false }
    password_confirmation { "password" }
  end

  factory :admin, class: User do
    email { "jsommers@colgate.edu" }
    password { "password"} 
    admin { true }
    password_confirmation { "password" }
  end

  factory :course do
    name { "A Course" }
    daytime { "TR 8:30-9:55" }

    transient do
      student_count { 10 }
    end

    after(:create) do |course, evaluator|
      create_list(:student, evaluator.student_count, courses: [course])
      course.questions.create(attributes_for(:question)) do |quest|
        quest.type = 'NumericQuestion'
      end
    end
  end

  sequence :opt do |i|
    "Option #{i}"
  end

  factory :multi_choice_option do
    value { generate(:opt) }
    question
  end

  factory :free_response_question do
    qname { "Gimme a free response" }
    type { "FreeResponseQuestion" }
  end

  factory :numeric_question do
    qname { "Gimme a number" }
    type { "NumericQuestion" }
  end

  factory :question do
    qname { "Select an option" }
    type { "MultiChoiceQuestion" }
    transient do
      option_count { 4 }
    end

    after(:create) do |question, evaluator|
      create_list(:multi_choice_option,  evaluator.option_count, question: question)
    end
  end

  factory :poll do
    question
  end
end
