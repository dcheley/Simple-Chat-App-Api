# Set path to use namespace on RSpec tests
require File.expand_path("../../../../../config/environment", __FILE__)
require 'spec_helper'
require 'rails_helper'

RSpec.describe Api::V1::ChatRoomsController, type: :controller do
  let!(:chat_room) { create(:chat_room) }

  let!(:valid_params) do
    { name: 'Test Chat Room' }
  end

  let!(:invalid_params) do
    { name: '' }
  end

  let!(:blank_name_error) do
    { "error": "Name can't be blank" }.to_json
  end

  describe 'POST /api/v1/chat_rooms' do
    context 'with valid params' do
      it 'creates a new chat room' do
        expect {
          post :create, params: valid_params
        }.to change(ChatRoom, :count).by(1)
      end

      it "returns json error Name can't be blank" do
        post :create, params: invalid_params
        expect(response.body).to eq(blank_name_error)
      end
    end

    context 'with invalid params' do
      it 'does not create a new chat room' do
        expect {
          post :create, params: invalid_params
        }.not_to change(ChatRoom, :count)
      end
    end
  end

  describe 'PUT /api/v1/chat_rooms/:id' do
    context 'with valid params' do
      before { patch :update, params: { id: chat_room.id, name: 'New Name' } }

      it 'should update the chat room' do
        chat_room.reload
        expect(chat_room.name).to eq('New Name')
      end
    end

    context 'with invalid params' do
      before { patch :update, params: { id: chat_room.id, name: '' } }

      it 'should not update the chat room' do
        chat_room.reload
        expect(chat_room.name).not_to eq(invalid_params[:name])
      end

      it "returns json error Name can't be blank" do
        chat_room.reload
        expect(response.body).to eq(blank_name_error)
      end
    end
  end

  describe 'GET /apis/v1/chat_rooms' do
    context 'without search params' do
      it 'should load a list of all existing chat room data' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response['chat_rooms'][0].keys).to match_array(['id', 'name', 'created_at', 'updated_at'])
      end
    end

    context 'with search valid params' do
      it 'should load chat rooms based on search params' do
        chat_room = ChatRoom.create(name: 'Test Chat Room')
        get :index, params: { search_chat_room: 'Test Chat Room' }
        json_response = JSON.parse(response.body)
        expect(json_response['chat_rooms'][0].keys).to eq(['id', 'name', 'created_at', 'updated_at'])
      end
    end

    context 'with search invalid params' do
      it 'should load chat rooms based on search params' do
        get :index, params: { search_chat_room: 'Test Chat Room' }
        json_response = JSON.parse(response.body)
        expect(json_response['chat_rooms']).to eq([])
      end
    end
  end

  describe 'GET /apis/v1/chat_rooms/:id' do
    context 'with valid id' do
      it 'should load data from a specific chat room' do
        get :show, params: { id: chat_room.id }
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['message', 'messages', 'message_count', 'user_count'])
      end
    end

    context 'without valid id' do
      it 'should not load any chat room data' do
        expect {
          get :show, params: { id: 99 }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
