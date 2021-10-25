require 'rails_helper'
require 'my_strava'

describe MyStrava::Athlete do
  WebMock.disable_net_connect!

  describe '.import' do
    subject { MyStrava::Athlete }
    let(:user) { create_user }
    let(:athlete) { build_athlete(user) }

    before do
      stub_const("MyStrava::Athlete::CACHE_FILE", 'test_athlete_cache.json')
    end

    before(:each) do
      cache_path = File.join(Rails.root, 'my-strava-cache', MyStrava::Athlete::CACHE_FILE)
      File.delete(cache_path) if File.exists?(cache_path)
    end

    before(:each) do
      @stub = stub_request(:get, /www.strava.com/).to_return({
        status: 200,
        headers: {'Content-Type' => 'application/json'},
        body: {
          id: athlete.external_id,
          firstname: athlete.first_name,
          lastname: athlete.last_name,
        }.to_json
      })
    end

    context 'When no cache and config.run = true' do
      let(:config) {{ user_id: user.id, run: true }}

      it 'calls strava api' do
        result = subject.import(config)
        expect(@stub).to have_been_requested
      end

      it 'persists athlete with data' do
        result = subject.import(config)
        expect(Athlete.count).to eq(1)
        expect(Athlete.first.as_json).to include_json({
          external_id: athlete.external_id,
          first_name: athlete.first_name,
          last_name: athlete.last_name,
        })
      end
    end

    context 'When no cache and config.run = false' do
      let(:config) {{ user_id: user.id, run: false }}

      it 'does not persist athlete' do
        result = subject.import(config)
        expect(Athlete.count).to eq(0)
      end
    end

    context 'When cache exists and config.run = false' do
      let(:config) {{ user_id: user.id, run: false }}
      let(:athlete_json) {{
        id: athlete.external_id,
        firstname: athlete.first_name,
        lastname: athlete.last_name,
      }.to_json}

      before do
        cache_path = File.join(Rails.root, 'my-strava-cache', MyStrava::Athlete::CACHE_FILE)
        File.write(cache_path, athlete_json, mode: 'w')
      end

      after do
        cache_path = File.join(Rails.root, 'my-strava-cache', MyStrava::Athlete::CACHE_FILE)
        File.delete(cache_path) if File.exists?(cache_path)
      end

      it 'does not call strava api' do
        result = subject.import(config)
        expect(@stub).to_not have_been_requested
      end
    end
  end
end
