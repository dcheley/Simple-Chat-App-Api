# This will guess the User class
FactoryBot.define do
  factory :message do
    user
    chat_room
    content { 'Hello everyone!' }
  end
end
