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
end
