# This will guess the User class
FactoryBot.define do
  factory :user do
    username {}
    email {}
    password { "123456" }
    password_confirmation { "123456" }
  end
end
