module Methods::User
  def self.included base
    base.class_eval do
      
      def self.role_power user
        return (roles.length - roles[user.role]) if (user.is_a? User)
        return roles.length - roles[user]
      end
    
      def self.PP
        User.all.order(id: :asc).each do  |item|
          puts item.as_json(:except => [:created_at, :updated_at, :jti])
        end
        return nil
      end

    end
  end
end