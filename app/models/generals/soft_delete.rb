module Generals::SoftDelete
    #soft delete config
    def soft_delete  
        update_attribute(:deleted_at, Time.current)  
    end 

    def active?
        !deleted_at?
    end
end