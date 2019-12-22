class SerializableUser < JSONAPI::Serializable::Resource
    type 'users'
    attributes :email, :role, :deleted_at, :avatar
  end
