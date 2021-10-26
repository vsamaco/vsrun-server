class SerializableUser < JSONAPI::Serializable::Resource
  type 'user'

  attributes :email

  attribute :athlete_id do
    @object.try(:athlete).try(:id)
  end

  link :self do
    @url_helpers.api_user_url(@object.id)
  end
end
