module  Scopes::Enrolment
    def self.included base
        base.class_eval do
            scope :in_coffee_shop, -> (coffee_shop) {Enrolment.joins("INNER JOIN tables ON tables.id = enrolments.table_id
                                                                      INNER JOIN events ON events.id = tables.event_id
                                                                      INNER JOIN coffee_shops ON coffee_shops.id = events.coffee_shop_id
                                                                      AND coffee_shops.id = #{coffee_shop.id}")}
            scope :in_event, -> (event) {joins(:table).where("tables.event_id = #{event.id}")}

            scope :for_table, -> (table) {where("table_id = #{table.id}")}
            scope :for_user, -> (user) {where("user_id = ?", user.id)}

            scope :active_enrolments, -> {where(deleted_at: nil)}
        end
    end
end
