# frozen_string_literal: true

FactoryBot.define do
  factory :review_app do
    pipeline
    app_id { Faker::Internet.uuid }
    branch { Faker::Hipster.words.join('-') }

    trait :potentially_extinct do
      last_active_at { 7.hours.ago }
    end
  end
end
