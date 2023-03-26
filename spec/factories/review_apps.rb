# frozen_string_literal: true

FactoryBot.define do
  factory :review_app do
    pipeline
    app_id { Faker::Internet.uuid }
  end
end
