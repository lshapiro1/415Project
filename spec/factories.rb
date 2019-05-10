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
    end
  end

  factory :numeric_question do
    qname { "a numeric question" }
    type { "NumericQuestion" }
  end

#  factory :free_response_question do
#    qname { "a free response question" }
#    type { "FreeResponseQuestion" }
#  end
end
