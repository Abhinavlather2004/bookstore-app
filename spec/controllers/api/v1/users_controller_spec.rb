# spec/controllers/api/v1/users_controller_spec.rb
require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  describe 'POST #signup' do
    let(:valid_params) do
      {
        user: {
          name: 'Abhinav',
          email: 'abhinav@gmail.com',
          password: 'Passw0rd!',
          mobile_number: '7082959391'
        }
      }
    end

    let(:invalid_params) do
      {
        user: {
          name: 'Abhinav',
          email: 'abhinav@invalid.com', # Invalid domain
          password: 'passw0rd',        # No uppercase
          mobile_number: '5082959391'  # Starts with 5
        }
      }
    end

    context 'with valid parameters' do
      it 'creates a new user and returns success' do
        post :signup, params: valid_params, as: :json
        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('user created successfully')
        expect(json['user']['email']).to eq('abhinav@gmail.com')
      end
    end

    context 'with invalid parameters' do
      it 'returns an error' do
        post :signup, params: invalid_params, as: :json
        expect(response).to have_http_status(422)
        json = JSON.parse(response.body)
        expect(json['error']).to include(match(/Email must be from a valid domain/))
        expect(json['error']).to include(match(/Password must be at least 8 characters/))
        expect(json['error']).to include(match(/Mobile number must be a 10-digit number/))
      end
    end
  end

  describe 'POST #login' do
    let!(:user) { create(:user, email: 'latherabhinav55@gmail.com', password: 'Passw0rd!') }
    let(:valid_login_params) do
      { user: { email: 'latherabhinav55@gmail.com', password: 'Passw0rd!' } }
    end
    let(:invalid_login_params) do
      { user: { email: 'latherabhinav55@gmail.com', password: 'wrongpass!' } }
    end

    context 'with valid credentials' do
      it 'logs in the user and returns a token' do
        post :login, params: valid_login_params, as: :json
        expect(response).to have_http_status(:ok)
        json = JSON.parse(response.body)
        expect(json['message']).to eq('Login successfull')
        expect(json['token']).to be_present
        expect(json['user']['email']).to eq('latherabhinav55@gmail.com')
      end
    end

    context 'with invalid credentials' do
      it 'returns an unauthorized error' do
        post :login, params: invalid_login_params, as: :json
        expect(response).to have_http_status(:unauthorized)
        json = JSON.parse(response.body)
        expect(json['error']).to eq('Invalid email or password')
      end
    end
  end
end