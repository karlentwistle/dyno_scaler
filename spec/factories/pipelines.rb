# frozen_string_literal: true

FactoryBot.define do
  factory :pipeline do
    organisation
    name { Faker::App.name }
    uuid { Faker::Internet.uuid }
    api_key { Faker::Internet.uuid }
    base_size { DynoSize.base_sizes.sample }
    boost_size { DynoSize.boost_sizes.sample }
  end
end
