module  Methods::CoffeeShop
    def self.included base
        base.class_eval do
            def self.PP
                CoffeeShop.all.order(id: :asc).each do  |item|
                  puts item.as_json(:except => [:created_at, :updated_at])
                end
                return nil
            end
        end
    end
end