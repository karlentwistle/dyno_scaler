# frozen_string_literal: true

FactoryBot.define do
  factory :pipeline do
    user
    uuid { Faker::Internet.uuid }
    api_key { Faker::Internet.uuid }
  end
end
