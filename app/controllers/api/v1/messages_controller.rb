module Api
  module V1
    class MessagesController < ActionController::Base
      skip_before_action :verify_authenticity_token
      before_action :set_messages

      def create
        @message = Message.create(
                     user: User.find_by(username: params[:username]),
                     chat_room: @chat_room,
                     content: params[:message]
                   )

        if @message.save
          # Could broadcast message to websocket here
          # ChatRoomChannel.broadcast_to(@chat_room, @message)
          render(json: { success: "success", message: @message }.to_json)
        else
          render(json: { error: @message.errors.full_messages[0] }.to_json)
        end
      end

    private

      def set_messages
        @chat_room = ChatRoom.find_by(name: params[:chat_room_name])
      end
    end
  end
end
