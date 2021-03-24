# Set path to use namespace on RSpec tests
require File.expand_path("../../../../../config/environment", __FILE__)
require 'spec_helper'
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  let!(:user) { create(:user) }

  let!(:valid_params) do
    {
      username: 'AccountName',
      email: 'user@email.com',
      password: '123456',
      password_confirmation: '123456'
    }
  end

  let!(:invalid_params) do
    {
      username: 'AccountName2',
      email: 'user@email.com'
    }
  end

  let!(:blank_password_error) do
    { "error": "Password can't be blank" }.to_json
  end

  describe 'POST /api/v1/users' do
    context 'with valid params' do
      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
      end

      it "returns json error Name can't be blank" do
        post :create, params: invalid_params
        expect(response.body).to eq(blank_password_error)
      end
    end

    context 'with invalid params' do
      it 'does not create a new user' do
        expect {
          post :create, params: invalid_params
        }.not_to change(User, :count)
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    context 'with valid params' do
      before { patch :update, params: { id: user.id, username: 'NewName', password: '123456', password_confirmation: '123456' } }

      it 'should update the user' do
        user.reload
        expect(user.username).to eq('NewName')
      end
    end

    context 'with invalid params' do
      before { patch :update, params: { id: user.id, username: '' } }

      it 'should not update the user' do
        user.reload
        expect(user.username).not_to eq(invalid_params[:username])
      end

      it "returns json error username can't be blank" do
        user.reload
        expect(response.body).to eq({ "error": "Username can't be blank" }.to_json)
      end
    end
  end

  describe 'GET /api/v1/users' do
    context 'without search params' do
      it 'should load a list of all existing user data' do
        get :index
        json_response = JSON.parse(response.body)
        expect(json_response['users'][0].keys).to match_array(['account_data', 'chat_room_count', 'message_count'])
      end
    end

    context 'with search valid params' do
      it 'should load users based on search params' do
        user = User.create(username: 'NewName', email: 'unused@email.com', password: '123456', password_confirmation: '123456')
        get :index, params: { search_username: 'NewName' }
        json_response = JSON.parse(response.body)
        expect(json_response['users'][0].keys).to eq(['account_data', 'chat_room_count', 'message_count'])
      end
    end

    context 'with search invalid params' do
      it 'should load users based on search params' do
        get :index, params: { search_username: 'FakeName' }
        json_response = JSON.parse(response.body)
        expect(json_response['users'][0]).to eq('No accounts found with the username FakeName')
      end
    end
  end

  describe 'GET /api/v1/users/:id' do
    context 'with valid id' do
      it 'should load data from a specific user' do
        get :show, params: { id: user.id }
        json_response = JSON.parse(response.body)
        expect(json_response.keys).to eq(['user', 'chat_room_count', 'message_count'])
      end
    end

    context 'without valid id' do
      it 'should not load any user data' do
        expect {
          get :show, params: { id: 99 }
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
