module  Methods::Table
    def self.included base
        base.class_eval do
            def self.PP
                Table.all.order(id: :asc).each do  |item|
                  puts item.as_json(:except => [:created_at, :updated_at, :jti])
                end
                return nil
            end
        end
    end
end