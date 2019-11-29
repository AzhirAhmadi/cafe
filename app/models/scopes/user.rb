module Scopes::User
    def self.included base
        base.class_eval do
            scope :without_coffee_shop, -> { where('NOT EXISTS(SELECT 1 FROM coffee_shops WHERE owner_id = users.id)') }
            scope :active_users, -> {where(deleted_at: nil)}
        end
    end
end