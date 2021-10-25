require 'rails_helper'

describe Api::ActivitiesController, type: :request do

  let (:user) { create_user }
  let (:athlete) { create_athlete }
  let (:activity) { create_activity }

  context 'When fetching an activity' do
    before do
      login_with_api(user)
      get "/api/activities/#{activity.id}", headers: {
        'Authorization': response.headers['Authorization']
      }
    end
  
    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns the activity' do
      expect(json['data']).to have_id(activity.id.to_s)
      expect(json['data']).to have_type('activity')
    end
  end

  context 'When a activity is missing' do
    before do
      login_with_api(user)
      get "/api/activities/blank", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 404' do
      expect(response.status).to eq(404)
    end
  end

  context 'When the Authorization header is missing' do
    before do
      get "/api/activities/#{activity.id}"
    end

    it 'returns 401' do
      expect(response.status).to eq(401)
    end
  end

  context 'When fetching activities for athlete' do
    before do
      login_with_api(user)
      athlete_id = activity.athlete_id
      get "/api/athletes/#{athlete_id}/activities", headers: {
        'Authorization': response.headers['Authorization']
      }
    end

    it 'returns 200' do
      expect(response.status).to eq(200)
    end

    it 'returns array of activities' do
      expect(json['data']).to be_a(Array)
    end

    it 'returns relationships' do
      expect(json['data'].first['relationships']).to_not be_empty
      expect(json['data'].first['relationships']['athlete']).to_not be_empty
    end
  end
end
