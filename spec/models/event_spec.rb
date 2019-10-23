# == Schema Information
#
# Table name: events
#
#  id               :integer          not null, primary key
#  name             :string           not null
#  description      :string           not null
#  deleted_at       :datetime
#  coffee_shop_id   :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  opens_at         :datetime         not null
#  enrol_start_time :datetime         not null
#  enrol_end_time   :datetime         not null
#  event_start_time :datetime         not null
#  event_end_time   :datetime         not null
#  closed_at        :datetime         not null
#

require 'rails_helper'

RSpec.describe Event, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
