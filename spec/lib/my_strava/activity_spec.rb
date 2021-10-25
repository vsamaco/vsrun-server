require 'rails_helper'
require 'my_strava'

describe MyStrava::Activity do
  WebMock.disable_net_connect!

  subject { MyStrava::Activity }
  let(:user) { create_user }
  let(:athlete) { create_athlete(user) }
  let(:activity) { build_activity(athlete) }

  before do
    stub_const("MyStrava::Activity::CACHE_FILE", 'test_athlete_cache.json')
  end

  before(:each) do
    cache_path = File.join(Rails.root, 'my-strava-cache', MyStrava::Activity::CACHE_FILE)
    File.delete(cache_path) if File.exists?(cache_path)
  end

  before(:each) do
    @stub = stub_request(:get, /www.strava.com/).to_return({
      status: 200,
      headers: {'Content-Type' => 'application/json'},
      body: [{
        id: activity.external_id,
        name: activity.name,
        athlete: {
          id: activity.athlete.external_id
        }
      }].to_json
    })
  end

  describe '.fetch_new_activities' do
    context 'when no cache' do
      let(:config) {{user_id: user.id, run: false}}
      it 'calls strava api' do
        result = subject.fetch_new_activities(config)
        expect(@stub).to have_been_requested
      end
    end

    context 'when cache exists' do
      let(:config) {{user_id: user.id, run: false}}
      let(:activity_json) {[{
        id: activity.external_id,
        name: activity.name,
      }].to_json}

      before do
        cache_path = File.join(Rails.root, 'my-strava-cache', MyStrava::Activity::CACHE_FILE)
        File.write(cache_path, activity_json, mode: 'w')
      end

      it 'does not call strava api' do
        result = subject.fetch_new_activities(config)
        expect(@stub).to_not have_been_requested
      end
    end
  end

  describe '.import_activities' do
    context 'when config.run = true' do
      before do
        @activities = subject.fetch_new_activities({user: user.id, run: false})
      end

      let(:config) {{user_id: user.id, activities: @activities, run: true}}

      it 'persists activity to database' do
        result = subject.import_activities(config)
        expect(Activity.count).to eq(1)
        expect(Activity.first.as_json).to include_json({
          external_id: activity.external_id,
          name: activity.name,
        })
      end
    end
    
    context 'when config.run = false' do
      before do
        @activities = subject.fetch_new_activities({run: false})
        athlete = activity.athlete
        athlete.save
      end
      let(:config) {{activities: @activities, run: false}}
      it 'does not persist activity' do
        result = subject.import_activities(config)
        expect(Activity.count).to eq(0)
      end
    end
  end
end
