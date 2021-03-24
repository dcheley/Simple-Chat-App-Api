module Api
  module V1
    class UsersController < ActionController::Base
      skip_before_action :verify_authenticity_token
      before_action :set_user, only: [:show, :update]

      def create
        @user = User.create(
                  username: params[:username],
                  email: params[:email],
                  password: params[:password],
                  password_confirmation: params[:password_confirmation]
                )

        if @user.save
          render(json: { success: "success", user: @user }.to_json)
        else
          render(json: { error: @user.errors.full_messages[0] }.to_json)
        end
      end

      # List all existing users
      # Search for user by username of users participating in a channel
      def index
        if params[:search_username].present?
          @users = User.where("lower(username) LIKE ?", "%#{params[:search_username].downcase}%").order('username ASC')
        else
          @users = User.all.order('username ASC')
        end

        @response = {}
        @response[:users] = []

        # Merge stats with user data
        if @users.empty? && params[:search_username].present?
          @response[:users] << "No accounts found with the username #{params[:search_username]}"
        elsif @users.empty? && params[:search_username].blank?
          @response[:users] << "No accounts found"
        else
          @users.each do |user|
            u = {}
            u[:account_data]    = user
            u[:chat_room_count] = user.messages.pluck(:chat_room_id).uniq.count
            u[:message_count]   = user.messages.count
            @response[:users] << u
          end
        end

        render(json: { users: @response[:users] }.to_json)
      end

      def show
        @chat_room_count = @user.messages.pluck(:chat_room_id).uniq.count
        @message_count = @user.messages.count

        render(json: { user: @user, chat_room_count: @chat_room_count, message_count: @message_count }.to_json)
      end

      def update
        if @user.update_attributes(user_params)
          render(json: { success: "success", user: @user }.to_json)
        else
          render(json: { error: @user.errors.full_messages[0] }.to_json)
        end
      end

    private

      def set_user
        @user = User.find(params[:id])
      end

      def user_params
        params.permit(:username, :email, :password, :password_confirmation)
      end
    end
  end
end
