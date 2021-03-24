class MessagesController < ApplicationController
  before_action :set_messages

  def create
    @message = Message.create(
                 user: current_user,
                 chat_room: @chat_room,
                 content: params[:message][:content]
               )

    ChatRoomChannel.broadcast_to(@chat_room, @message)
  end

private

  def set_messages
    @chat_room = ChatRoom.find(params[:message][:chat_room_id])
  end
end
