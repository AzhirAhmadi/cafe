class SerializableEvent < JSONAPI::Serializable::Resource
    type 'event'
  
    attributes :name, :description, :opens_at, :enrol_start_time, :enrol_end_time,
     :event_start_time, :event_end_time, :closed_at, :deleted_at, :status

    has_one :coffee_shop do
      data do
        @object.coffee_shop
      end
    end
  end