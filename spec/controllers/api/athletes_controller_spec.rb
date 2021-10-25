require 'rails_helper'

describe Api::AthletesController, type: :request do

  let (:user) { create_user }
  let (:athlete) { create_athlete }

  context 'When fetching a athlete' do
    before do
      login_with_api(user)
      get "/api/athletes/#{athlete.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end
  
    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the user' do
      expect(json['data']).to have_id(athlete.id.to_s)
      expect(json['data']).to have_type('athlete')
    end

    it 'returns relationships' do
      expect(json['data']['relationships']).to_not be_empty
      expect(json['data']['relationships']['activities']).to_not be_empty
    end
  end

  context 'When a athlete is missing' do
    before do
      login_with_api(user)
      get "/api/athletes/blank", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      get "/api/athletes/#{athlete.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end
end