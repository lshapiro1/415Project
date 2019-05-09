FactoryBot.define do
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
end
