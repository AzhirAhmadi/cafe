class SerializableEnrolment < JSONAPI::Serializable::Resource
    type 'enrolment'
  
    has_one :table
    has_one :user
  end