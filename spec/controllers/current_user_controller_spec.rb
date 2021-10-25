require 'rails_helper'

describe CurrentUserController, type: :request do
  describe 'GET /current_user' do
    context 'contains valid jwt token' do
      let(:user) { create_user }

      before do
        login_with_api(user)
        @jwt_token = response.headers['Authorization']

        get current_user_url, headers: {
          'Content-Type': 'application/json',
          'Authorization': @jwt_token
        }
      end

      it 'returns 200 status' do
        expect(response.status).to eq(200)
      end

      it 'returns user' do
        expect(json['data']).to have_id(user.id.to_s)
      end
    end

    context 'missing jwt token' do
      let(:user) { create_user }

      before do
        login_with_api(user)

        get current_user_url, headers: {
          'Content-Type': 'application/json'
        }
      end

      it 'returns 401 status' do
        expect(response.status).to eq(401)
      end
    end
  end
end
