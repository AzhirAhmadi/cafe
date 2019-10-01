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
  enum role: [:sys_master, :sys_admin, :sys_expert, :cafe_ower,:player]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :player
  end
end
