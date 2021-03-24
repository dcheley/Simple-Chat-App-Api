class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    if @user != current_user
      redirect_to root_url
    end

    @chat_room_count = @user.messages.pluck(:chat_room_id).uniq.count
    @message_count   = @user.messages.count
  end

  # List all existing users
  # Search for user by username of users participating in a channel
  def index
    if params[:search].present?
      @users = User.where("lower(username) LIKE ?", "%#{params[:search].downcase}%").order('username ASC')
    else
      @users = User.all.order('username ASC')
    end
  end
end
