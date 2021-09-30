require 'faker'
require 'factory_bot_rails'

module ActivityHelpers
  def create_activity
    athlete = create_athlete

    FactoryBot.create(:activity, 
            external_id: Faker::String.random(length: 6), 
            name: Faker::Lorem::sentence(word_count: 3),
            activity_type: 'Run',
            start_date: DateTime.now,
            distance: Faker::Number.between(from: 1000.0, to: 10000.0),
            moving_time: Faker::Number.between(from: 100.0, to: 1000.0),
            elapsed_time: Faker::Number.between(from: 100.0, to: 1000.0),
            total_elevation_gain: Faker::Number.between(from: 100.0, to: 500.0),
            external_gear_id: Faker::String.random(length: 6),
            external_athlete_id: Faker::String.random(length: 6),
            athlete: athlete
        )
  end

    def build_athlete(athlete)
      athlete = build_athlete

      FactoryBot.build(:activity, 
            external_id: Faker::String.random(length: 6), 
            name: Faker::Lorem::sentence(word_count: 3),
            activity_type: 'Run',
            start_date: DateTime.now,
            distance: Faker::Number.between(from: 1000.0, to: 10000.0),
            moving_time: Faker::Number.between(from: 100.0, to: 1000.0),
            elapsed_time: Faker::Number.between(from: 100.0, to: 1000.0),
            total_elevation_gain: Faker::Number.between(from: 100.0, to: 500.0),
            external_gear_id: Faker::String.random(length: 6),
            external_athlete_id: Faker::String.random(length: 6),
            athlete: athlete
        )
  end
end
