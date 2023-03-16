# frozen_string_literal: true

FactoryBot.define do
  factory :dyno do
    pipeline
    app_id { Faker::Internet.uuid }
  end
end
