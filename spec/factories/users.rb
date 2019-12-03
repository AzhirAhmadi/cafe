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

require 'faker'

FactoryBot.define do
  # :sys_master, :sys_admin, :sys_expert, :coffee_owner,:player

    factory :player, class: ApiUser do
      sequence(:email) { |n| "test#{n}#{rand(100000..999999).to_s}@player.com" }
      password { "123456" }
      role {"player"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :coffee_owner, class: ApiUser do
      sequence(:email) { |n| "test#{n}#{rand(100000..999999).to_s}@coffee_owner.com" }
      password { "123456" }
      role {"coffee_owner"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :sys_expert, class: ApiUser do
      sequence(:email) { |n| "test#{n}#{rand(100000..999999).to_s}@sys_expert.com" }
      password { "123456" }
      role {"sys_expert"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :sys_admin, class: ApiUser do
      sequence(:email) { |n| "test#{n}#{rand(100000..999999).to_s}@sys_admin.com" }
      password { "123456" }
      role {"sys_admin"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :sys_master, class: ApiUser do
      sequence(:email) { |n| "test#{n}#{rand(100000..999999).to_s}@sys_master.com" }
      password { "123456" }
      role {"sys_master"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end
end
