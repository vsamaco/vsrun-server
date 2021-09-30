class SerializableAthlete < JSONAPI::Serializable::Resource
  type 'athletes'

  attributes :external_id, :first_name, :last_name

  link :self do
    @url_helpers.api_athlete_url(@object.id)
  end
end
