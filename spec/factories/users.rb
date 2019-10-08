require 'faker'

FactoryBot.define do
  # :sys_master, :sys_admin, :sys_expert, :cafe_owner,:player

    factory :player, class: ApiUser do
      sequence(:email) { |n| "test#{n}@player.com" }
      password { "123456" }
      role {"player"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :cafe_owner, class: ApiUser do
      sequence(:email) { |n| "test#{n}@cafe_owner.com" }
      password { "123456" }
      role {"cafe_owner"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :sys_expert, class: ApiUser do
      sequence(:email) { |n| "test#{n}@sys_expert.com" }
      password { "123456" }
      role {"sys_expert"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :sys_admin, class: ApiUser do
      sequence(:email) { |n| "test#{n}@sys_admin.com" }
      password { "123456" }
      role {"sys_admin"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end

    factory :sys_master, class: ApiUser do
      sequence(:email) { |n| "test#{n}@sys_master.com" }
      password { "123456" }
      role {"sys_master"}
      jti {Faker::Alphanumeric.alphanumeric(number: 20)}
    end
end