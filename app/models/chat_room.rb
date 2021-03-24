class ChatRoom < ApplicationRecord
  has_many :messages, dependent: :destroy, inverse_of: :chat_room

  validates :name, uniqueness: true, presence: true, length: { maximum: 30 }
end
