module ErrorHandling::Errors::BoardGame
    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:board_game].errors
        end
    end

    class DataBaseUpdate < ErrorHandling::Error
        def message
            args[:board_game].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for create board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update board_game must be provided like this:{\"board_game\" :{\"name\" : \"board_game_name\", \"publisher\":\"board_game_publisher\", \"min_player\": \"board_game_min_player\", \"max_player\": \"board_game_max_player\", \"play_time\": \"board_game_play_time\"[, \"description\": \"board_game_description\"]}}"
        end
    end

    class DeletedBoardGame < ErrorHandling::Error
        def message
           "This board_game has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end