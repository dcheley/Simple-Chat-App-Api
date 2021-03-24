# Set path to use namespace on RSpec tests
require File.expand_path("../../../../../config/environment", __FILE__)
require 'spec_helper'
require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do

  let!(:user) { create(:user) }
  let!(:chat_room) { create(:chat_room) }
  let!(:message) { build(:message) }

  let!(:valid_params) do
    {
      username: user.username,
      chat_room_name: chat_room.name,
      message: 'Hello everyone!'
    }
  end

  let!(:invalid_params) do
    {
      username: user.username,
      chat_room_name: chat_room.name,
      message: ''
    }
  end

  let!(:blank_content_error) do
    { "error": "Content can't be blank" }.to_json
  end

  describe 'POST /api/v1/messages' do
    context 'with valid params' do
      it 'creates a new message' do
        byebug
        expect {
          post :create, params: valid_params
        }.to change(Message, :count).by(1)
      end

      it "returns json error Content can't be blank" do
        post :create, params: invalid_params
        expect(response.body).to eq(blank_content_error)
      end
    end

    context 'with invalid params' do
      it 'does not create a new message' do
        expect {
          post :create, params: invalid_params
        }.not_to change(Message, :count)
      end
    end
  end
end
