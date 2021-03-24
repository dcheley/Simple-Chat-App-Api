module Api
  module V1
    class ChatRoomsController < ActionController::Base
      skip_before_action :verify_authenticity_token
      before_action :set_chat_room, except: :index

      def create
        @chat_room = ChatRoom.create(name: params[:name])

        if @chat_room.save
          render(json: { success: "success", chat_room: @chat_room }.to_json)
        else
          render(json: { error: @chat_room.errors.full_messages[0] }.to_json)
        end
      end

      # List all available channels (chat rooms)
      # Search for channels by name or by username of users participating in a channel
      def index
        if params[:search_chat_room].present?
          @chat_rooms = ChatRoom.where("lower(name) LIKE ?", "%#{params[:search_chat_room].downcase}%").order('name ASC')
        else
          @chat_rooms = ChatRoom.all.order('name ASC')
        end

        if @chat_rooms.empty? && params[:search_chat_room].present?
          @chat_rooms = []
          @chat_rooms << "No chat rooms found with the name #{params[:search_chat_room]}"
        elsif @chat_rooms.empty? && params[:search_chat_room].blank?
          @chat_rooms = []
          @chat_rooms << "No chat rooms found"
        end

        render(json: { chat_rooms: @chat_rooms }.to_json)
      end

      # View and send messages that persist within a certain channels (chat rooms) a user joins
      # Display stats of the channel (chat room) being viewed
      def show
        @message       = Message.new(chat_room: @chat_room)
        @messages      = @chat_room.messages.includes(:user)
        @message_count = @chat_room.messages.count
        @user_count    = @chat_room.messages.pluck(:user_id).uniq.count

        render(json: { message: @message, messages: @messages, message_count: @message_count, user_count: @user_count }.to_json)
      end

      def update
        if @chat_room.update_attributes(chat_room_params)
          render(json: { success: "success", chat_room: @chat_room }.to_json)
        else
          render(json: { error: @chat_room.errors.full_messages[0] }.to_json)
        end
      end

    private

      def chat_room_params
        params.permit(:name)
      end

      def set_chat_room
        @chat_rooms = ChatRoom.all.order('name ASC')
        if params[:id]
          @chat_room = ChatRoom.find(params[:id])
        end
      end
    end
  end
end
