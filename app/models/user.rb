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

class User < ApplicationRecord
  include Generals::SoftDelete

  include Methods::User
  include Scopes::User
  include Validations::User
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :validatable
  
  has_many :created_coffee_shop, class_name: 'CoffeeShop', foreign_key: 'creator_id'
  has_many :maintained_coffee_shop, class_name: 'CoffeeShop', foreign_key: 'maintainer_id'
  has_many :owened_coffee_shop, class_name: 'CoffeeShop', foreign_key: 'owner_id', dependent: :destroy
  has_many :enrolments
  has_many :enroled_tables, through: :enrolments, source: :table
  has_one :avatar, as: :parent, class_name: 'Image', dependent: :destroy

  #JWT config
  before_create :add_jti
  def add_jti
  self.jti ||= SecureRandom.uuid
  end


  #role config
  enum role: [:sys_master, :sys_admin, :sys_expert, :coffee_owner,:player]
  after_initialize :set_default_role, :if => :new_record?

  def set_default_role
    self.role ||= :player
  end

#soft delete config for davise
  def active_for_authentication?  
    raise ErrorHandling::Errors::User::DeletedUser.new(deleted_at: deleted_at) if deleted_at?  
    return true
  end 
end
