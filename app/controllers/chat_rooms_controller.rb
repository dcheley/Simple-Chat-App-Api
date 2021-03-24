class ChatRoomsController < ApplicationController
  before_action :set_chat_room, except: :index

  def create
    @chat_room = ChatRoom.new(chat_room_params)

    if @chat_room.save
      flash[:success] = "Chat room #{@chat_room.name} created"
      redirect_to chat_rooms_path
    else
      render :new
    end
  end

  def edit
  end

  def new
    @chat_room = ChatRoom.new
  end

  # List all available channels (chat rooms)
  # Search for channels by name or by username of users participating in a channel
  def index
    if params[:search].present?
      @chat_rooms = ChatRoom.where("lower(name) LIKE ?", "%#{params[:search].downcase}%").order('name ASC')
    else
      @chat_rooms = ChatRoom.all.order('name ASC')
    end
  end

  # View and send messages that persist within a certain channels (chat rooms) a user joins
  # Display stats of the channel (chat room) being viewed
  def show
    @message       = Message.new(chat_room: @chat_room)
    @messages      = @chat_room.messages.includes(:user)
    @message_count = @chat_room.messages.count
    @user_count    = @chat_room.messages.pluck(:user_id).uniq.count
  end

  def update
    if @chat_room.update_attributes(chat_room_params)
      flash[:success] = "Chat room #{@chat_room.name} updated"
      redirect_to chat_rooms_path
    else
      render :new
    end
  end

private

  def chat_room_params
    params.require(:chat_room).permit(:name)
  end

  def set_chat_room
    @chat_rooms = ChatRoom.all.order('name ASC')
    if params[:id]
      @chat_room = ChatRoom.find(params[:id])
    end
  end
end
