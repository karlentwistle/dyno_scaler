# frozen_string_literal: true

FactoryBot.define do
  factory :pipeline do
    uuid { Faker::Internet.uuid }
    api_key { Faker::Internet.uuid }
  end
end
