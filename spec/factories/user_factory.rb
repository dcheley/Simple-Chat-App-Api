# This will guess the User class
FactoryBot.define do
  factory :user do
    username { 'Tester' }
    email { 'factory@email.com' }
    password { '123456' }
    password_confirmation { '123456' }
  end
end
