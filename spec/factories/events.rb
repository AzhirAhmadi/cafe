FactoryBot.define do
  factory :event do
    name { "Event Name" }
    description { "Event Description"}
    association :coffee_shop, factory: :coffee_shop

    opens_at { Time.now + 1.days  }

    enrol_start_time { Time.now + 1.days + 8.hours }
    enrol_end_time { Time.now + 1.days + 20.hours }

    event_start_time { Time.now + 2.days + 8.hours}
    event_end_time { Time.now + 2.days + 20.hours}

    closed_at { Time.now + 3.days  }
  end
end
