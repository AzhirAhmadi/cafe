module  Validations::CoffeeShop
    def self.included base
        base.class_eval do
            validates :name, uniqueness: { case_sensitive: false }
            validates :owner_id, uniqueness: { case_sensitive: false}
        
            validates :name, :address, :owner_id, :creator_id, presence: true

            include ModelValidate::CoffeeShop
            validate :active_owner
            validate :active_maintainer
            validate :active_creator, on: [:create]

            validate :owner_role
            validate :maintainer_role
            validate :creator_role, on: [:create]
        end
    end
end