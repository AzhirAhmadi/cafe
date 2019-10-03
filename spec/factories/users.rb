FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "test#{n}@test.com" }
      password { "123456" }
      role {"player"}
    end
end