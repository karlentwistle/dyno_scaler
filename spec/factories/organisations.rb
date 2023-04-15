# frozen_string_literal: true

FactoryBot.define do
  factory :organisation do
    name { Faker::Company.name }
    hosted_domain { Faker::Internet.domain_name }
  end
end
