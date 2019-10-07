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
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable

  #JWT config
  before_create :add_jti
  def add_jti
  self.jti ||= SecureRandom.uuid
  end


  #role config
  enum role: [:sys_master, :sys_admin, :sys_expert, :cafe_owner,:player]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :player
  end

  def soft_delete  
    update_attribute(:deleted_at, Time.current)  
  end 

  def active_for_authentication?  
    raise ErrorHandling::Errors::User::DeletedUser.new(deleted_at: deleted_at) if deleted_at?  
    return true
  end 

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
