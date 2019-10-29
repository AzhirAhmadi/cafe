# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  jti                    :string           not null
#  role                   :integer
#  deleted_at             :datetime
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_jti                   (jti) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class ApiUser < User
    include Devise::JWT::RevocationStrategies::JTIMatcher
    devise :jwt_authenticatable, jwt_revocation_strategy: self
    validates :jti, presence: true
    
    def generate_jwt
        JWT.encode({ id: id,
                    exp: 5.days.from_now.to_i },
                    Rails.env.devise.jwt.secret_key)
    end
end
