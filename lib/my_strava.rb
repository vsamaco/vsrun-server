module MyStrava
  STRAVA_CLIENT = Strava::Api::Client.new(
    access_token: Rails.application.config.my_strava.access_token
  )

  module Caching
    extend ActiveSupport::Concern

    def cache_path
      File.join(Rails.root, 'my-strava-cache', self::CACHE_FILE)
    end

    def cache_exists
      File.exists?(cache_path)
    end

    def cache_resource(data)
      json = JSON.pretty_generate(data)
      File.write(cache_path, json, mode: 'w')
    end

    def read_cache(object_class)
      file = File.read(cache_path)
      json = JSON.parse(file, object_class: object_class)
      json
    end
  end

  module Athlete
    extend MyStrava::Caching

    CACHE_FILE = 'athlete_cache.json'

    def self.import(params)
      user_id = params[:user_id]
      run = params[:run]
      strava_athlete = read_athlete

      user = User.find(user_id)
      athlete = ::Athlete.find_or_initialize_by(external_id: strava_athlete.id, user: user)
      athlete.assign_attributes(initialize_athlete(strava_athlete))
      action = athlete.id ? 'Updated' : 'Created'

      athlete.save if run
      Rails.logger.info "#{run ? '' : 'Test'} #{action} athlete: #{athlete.id}"
      athlete
    end

    private

    def self.initialize_athlete(strava_athlete)
      {
        external_id: strava_athlete.id,
        first_name: strava_athlete.firstname,
        last_name: strava_athlete.lastname,
        shoes: strava_athlete.shoes
      }
    end

    def self.read_athlete
      if cache_exists
        Rails.logger.info "Reading athlete cache"
        json = read_cache(::Strava::Models::Athlete)
        json
      else
        Rails.logger.info "Fetching external athlete"
        athlete = fetch_athlete
        cache_resource(athlete)
        athlete
      end
    end

    def self.fetch_athlete
      MyStrava::STRAVA_CLIENT.athlete
    end
  end

  module Activity
    extend MyStrava::Caching

    CACHE_FILE = 'activities_cache.json'

    def self.fetch_new_activities(params)
      # read cache or strava api
      activities = read_activities

      activity_ids = activities.map {|a| a.id }
      existing_activity_ids = ::Activity.where(:external_id => activity_ids).map {|a| a.external_id }
      new_activities = activities.reject { |a| existing_activity_ids.include?(a.id.to_s) }

      new_activities
    end

    def self.import_activities(params)
      activities = params[:activities] || []
      return if activities.empty?
    
      run = params[:run]
      user_id = params[:user_id]

      athlete = ::Athlete.find_by(user_id: user_id)
      activities.each do |external_activity|
        activity = ::Activity.find_or_initialize_by(external_id: external_activity.id)
        activity.assign_attributes(initialize_activity(athlete, external_activity))
        action = activity.id ? 'Updated' : 'Created'

        activity.save if run
        Rails.logger.info "#{run ? '' : 'Test'} #{action} Activity: #{external_activity.id}"
      end
    end

    private

    def self.initialize_activity(athlete, activity)
      {
        external_id: activity.id,
        name: activity.name,
        activity_type: activity.type,
        moving_time: activity.moving_time,
        start_date: activity.start_date,
        distance: activity.distance,
        total_elevation_gain: activity.total_elevation_gain,
        start_latitude: activity.start_latitude,
        start_longitude: activity.start_longitude,
        end_latitude: activity.end_latlng ? activity.end_latlng[0] : nil,
        end_longitude: activity.end_latlng ? activity.end_latlng[1] : nil,
        map: activity.map,
        external_gear_id: activity.gear_id,
        external_athlete_id: activity.athlete.id,
        athlete: athlete,
      }
    end

    def self.fetch_activities(per_page=30, page=0)
      MyStrava::STRAVA_CLIENT.athlete_activities
    end

    def self.read_activities
      if cache_exists
        Rails.logger.info "Reading activities cache"
        json = read_cache(::Strava::Models::Activity)
        json
      else
        Rails.logger.info "Fetching external activities"
        activities = fetch_activities
        cache_resource(activities)
        activities
      end
    end
  end
end
