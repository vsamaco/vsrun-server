class SerializableActivity < JSONAPI::Serializable::Resource
  type 'activity'

  attributes :external_id, :name, :activity_type, :moving_time, :elapsed_time, :start_date,
             :distance, :total_elevation_gain, :map, :laps, :splits, :start_latitude,
             :start_longitude, :end_latitude, :end_longitude, :external_gear_id,
             :external_athlete_id, :athlete_id

  belongs_to :athlete do
    link :self do
      @url_helpers.api_athlete_url(@object.athlete.id)
    end
  end

  link :self do
    @url_helpers.api_activity_url(@object.id)
  end
end
