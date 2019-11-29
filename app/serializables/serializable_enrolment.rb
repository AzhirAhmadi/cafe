class SerializableEnrolment < JSONAPI::Serializable::Resource
    type 'enrolment'
  
    attributes :user, :table
  end