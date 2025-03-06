FactoryBot.define do
  factory :user do
    name { "Abhinav" } # Valid: starts with capital, 7 letters, no digits/special chars
    email { Faker::Internet.email(domain: 'gmail.com') }
    password { "Passw0rd!" }
    mobile_number { "7#{Faker::Number.number(digits: 9)}" }
  end
end