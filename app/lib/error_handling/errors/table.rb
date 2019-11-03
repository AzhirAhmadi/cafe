module ErrorHandling::Errors::Table
    class DataBaseFind < ErrorHandling::Error
        def message
            "Couldn't find table"
        end
    end

    class DataBaseCreation < ErrorHandling::Error
        def message
            args[:table].errors
        end
    end

    class DataBaseUpdate < ErrorHandling::Error
        def message
            args[:table].errors
        end
    end

    class CreationParams < ErrorHandling::Error
        def message
            "params for create table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}"
        end
    end

    class UpdateParams < ErrorHandling::Error
        def message
            "params for update table must be provided like this:{\"table\": {\"capacity\": 99, \"table_code\": \"code_99\", \"board_game_id\": \"board_game.id\"}}"
        end
    end

    class Deletedtable < ErrorHandling::Error
        def message
           "This table has been deleted at: [" + args[:deleted_at].to_s + "]"
        end
    end
end