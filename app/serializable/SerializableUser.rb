class SerializableUser < JSONAPI::Serializable::Resource
  type 'user'

  attributes :email

  link :self do
    @url_helpers.api_user_url(@object.id)
  end
end
