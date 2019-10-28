class SerializableBoardGame < JSONAPI::Serializable::Resource
    type 'board_game'
  
    attributes :name, :publisher, :min_player, :max_player, :play_time, :deleted_at

    has_one :creator do
      data do
        @object.creator
      end
    end
  end