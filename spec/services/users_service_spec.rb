# spec/services/users_service_spec.rb
require 'rails_helper'

RSpec.describe UsersService, type: :service do
  describe '.signup' do
    let(:valid_params) do
      {
        name: 'Abhinav',
        email: 'abhinav@gmail.com',
        password: 'Passw0rd!',
        mobile_number: '7082959391'
      }
    end

    let(:invalid_params) do
      {
        name: 'Abhinav',
        email: 'abhinav@invalid.com',
        password: 'passw0rd',
        mobile_number: '5082959391'
      }
    end

    context 'with valid params' do
      it 'creates a user and returns success' do
        result = UsersService.signup(valid_params)
        expect(result[:success]).to be true
        expect(result[:message]).to eq('user created successfully')
        expect(result[:user].email).to eq('abhinav@gmail.com')
      end
    end

    context 'with invalid params' do
      it 'returns validation errors' do
        result = UsersService.signup(invalid_params)
        expect(result[:error]).to include(match(/Email must be from a valid domain/))
        expect(result[:error]).to include(match(/Password must be at least 8 characters/))
        expect(result[:error]).to include(match(/Mobile number must be a 10-digit number/))
      end
    end
  end

  describe '.login' do
    let!(:user) { create(:user, email: 'latherabhinav55@gmail.com', password: 'Passw0rd!') }
    let(:valid_params) { { email: 'latherabhinav55@gmail.com', password: 'Passw0rd!' } }
    let(:invalid_params) { { email: 'latherabhinav55@gmail.com', password: 'wrongpass!' } }

    context 'with valid credentials' do
      it 'returns a success response with token' do
        allow(JsonWebToken).to receive(:encode).and_return('fake-jwt-token')
        result = UsersService.login(valid_params)
        expect(result[:success]).to be true
        expect(result[:message]).to eq('Login successfull')
        expect(result[:token]).to eq('fake-jwt-token')
        expect(result[:user].email).to eq('latherabhinav55@gmail.com')
      end
    end

    context 'with invalid credentials' do
      it 'returns an error' do
        result = UsersService.login(invalid_params)
        expect(result[:success]).to be false
        expect(result[:error]).to eq('Invalid email or password')
      end
    end

    context 'with non-existent email' do
      it 'returns an error' do
        result = UsersService.login({ email: 'nonexistent@gmail.com', password: 'Passw0rd!' })
        expect(result[:success]).to be false
        expect(result[:error]).to eq('Invalid email or password')
      end
    end
  end
end