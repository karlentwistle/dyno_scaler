# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "user#{n}@example.com"
  end

  factory :user do
    organisation
    email
    password { 'password' }
  end

  trait :manager do
    after(:create) do |user|
      user.add_role :manager, user.organisation
    end
  end

  trait :viewer do
    after(:create) do |user|
      user.add_role :viewer, user.organisation
    end
  end
end
