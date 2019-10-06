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

  def self.role_power user
    roles.length - roles[user.role]
  end
end
