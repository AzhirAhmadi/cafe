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
# Indexes
#
#  index_events_on_coffee_shop_id  (coffee_shop_id)
#

FactoryBot.define do

  factory :event, class: Event do
    name {"Event Name (event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at {Time.now + 1.days}

    enrol_start_time {Time.now + 2.days}
    enrol_end_time {Time.now + 3.days}

    event_start_time {Time.now + 4.days}
    event_end_time {Time.now + 5.days}

    closed_at {Time.now + 6.days}
  end

  factory :locked_event, class: Event do
    name {"Event Name (locked_event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at {Time.now + 1.days}

    enrol_start_time {Time.now + 2.days}
    enrol_end_time {Time.now + 3.days}

    event_start_time {Time.now + 4.days}
    event_end_time {Time.now + 5.days}

    closed_at {Time.now + 6.days}
  end

  factory :opened_event, class: Event do
    name {"Event Name (opened_event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at {Time.now - 1.days}

    enrol_start_time {Time.now + 1.days}
    enrol_end_time {Time.now + 2.days}

    event_start_time {Time.now + 3.days}
    event_end_time {Time.now + 4.days}

    closed_at {Time.now + 5.days}
  end

  factory :enroled_event, class: Event do
    name {"Event Name (enroled_event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at {Time.now - 2.days}

    enrol_start_time {Time.now - 1.days}
    enrol_end_time {Time.now + 1.days}

    event_start_time {Time.now + 2.days}
    event_end_time {Time.now + 3.days}

    closed_at {Time.now + 4.days}
  end

  factory :started_event, class: Event do
    name {"Event Name (started_event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at {Time.now - 4.days}

    enrol_start_time {Time.now - 3.days}
    enrol_end_time {Time.now - 2.days}

    event_start_time {Time.now - 1.days}
    event_end_time {Time.now + 1.days}

    closed_at {Time.now + 2.days}
  end

  factory :ended_event, class: Event do
    name {"Event Name (ended_event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at {Time.now - 5.days}

    enrol_start_time {Time.now - 4.days}
    enrol_end_time {Time.now - 3.days}

    event_start_time {Time.now - 2.days}
    event_end_time {Time.now - 1.days}

    closed_at {Time.now + 1.days}
  end

  factory :closed_event, class: Event do
    name {"Event Name (closed_event)"}
    description {"Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at { Time.now - 6.days}

    enrol_start_time { Time.now - 5.days}
    enrol_end_time { Time.now - 4.days}

    event_start_time { Time.now - 3.days}
    event_end_time { Time.now - 2.days}

    closed_at { Time.now - 1.days  }
  end
end
