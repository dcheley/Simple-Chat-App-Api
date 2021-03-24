# Set path to use namespace on RSpec tests
require File.expand_path("../../../../../config/environment", __FILE__)
require 'spec_helper'
require 'rails_helper'

RSpec.describe Api::V1::MessagesController, type: :controller do
  let!(:message) { create(:message) }

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
      it 'creates a new Chat room' do
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
      it 'does not create a new Chat room' do
        expect {
          post :create, params: invalid_params
        }.not_to change(ChatRoom, :count)
      end
    end
  end
end
