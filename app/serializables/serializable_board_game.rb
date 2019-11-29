class SerializableBoardGame < JSONAPI::Serializable::Resource
    type 'board_game'
  
    attributes :name, :publisher, :min_player, :max_player, :play_time, :deleted_at

    has_one :coffee_shop do
      data do
        @object.coffee_shop
      end
    end
  end