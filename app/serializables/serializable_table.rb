class SerializableTable < JSONAPI::Serializable::Resource
    type 'table'
  
    attributes :capacity, :table_code

    has_one :event do
      data do
        @object.event
      end
    end

    has_one :board_game do
      data do
        @object.board_game
      end
    end
  end