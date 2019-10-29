# == Schema Information
#
# Table name: coffee_shops
#
#  id            :integer          not null, primary key
#  name          :string           not null
#  address       :string           not null
#  owner_id      :integer          not null
#  creator_id    :integer          not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  deleted_at    :datetime
#  maintainer_id :integer          not null
#
# Indexes
#
#  index_coffee_shops_on_creator_id     (creator_id)
#  index_coffee_shops_on_maintainer_id  (maintainer_id)
#  index_coffee_shops_on_owner_id       (owner_id)
#

require 'faker'

FactoryBot.define do
  factory :coffee_shop do
    sequence(:name) { |n| "CoffeeShopName#{n}" }
    sequence(:address) { |n| "CoffeeShopAddress#{n}" }

    association :owner, factory: :coffee_owner
    association :maintainer, factory: :sys_expert
    association :creator, factory: :sys_admin
  end
end
