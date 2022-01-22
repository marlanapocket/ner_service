class SerializableUser < JSONAPI::Serializable::Resource
    type 'users'

    attributes :email

end