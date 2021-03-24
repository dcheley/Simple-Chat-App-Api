class Message < ApplicationRecord
  belongs_to :chat_room, inverse_of: :messages
  belongs_to :user

  # This function adds a sender's username to message data if message.user exists
  def as_json(options)
    if user
      super(options).merge(user_name: user.username)
    end
  end
end
