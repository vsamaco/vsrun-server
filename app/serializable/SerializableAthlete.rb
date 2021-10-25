class SerializableAthlete < JSONAPI::Serializable::Resource
  type 'athlete'

  attributes :external_id, :first_name, :last_name

  has_many :activities do
    link :self do
      @url_helpers.api_athlete_activities_url(@object.id)
    end
  end

  link :self do
    @url_helpers.api_athlete_url(@object.id)
  end
end
