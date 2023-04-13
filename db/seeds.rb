# frozen_string_literal: true

require 'faker'

PIPELINE_COUNT = 2
DYNO_COUNT = 10 # per pipeline

def generate_branch_name
  "#{Faker::Lorem.words(number: rand(1..10)).map(&:downcase).join('-')}-#{Faker::Number.number(digits: 5)}"
end

def pipeline_attributes(user)
  {
    uuid: Faker::Internet.uuid,
    api_key: Faker::Internet.uuid,
    base_size: DynoSize.base_sizes.sample,
    boost_size: DynoSize.boost_sizes.sample,
    name: Faker::App.name,
    user:
  }
end

def review_app_attributes(pipeline)
  current_size = [nil, DynoSize.base_sizes.sample].sample

  {
    app_id: Faker::Internet.uuid,
    pipeline:,
    last_active_at: Faker::Time.between(from: 30.days.ago, to: Time.zone.now),
    branch: generate_branch_name,
    pr_number: [nil, rand(1..1000)].sample,
    current_size:
  }
end

organisation = Organisation.create!(name: 'Default', hosted_domain: 'example.org')

admin = User.create!(
  email: 'admin@example.org',
  password: '12345678',
  organisation:,
  admin: true
)

pipelines = Pipeline.create!(
  Array.new(PIPELINE_COUNT) { pipeline_attributes(admin) }
)

pipelines.each do |pipeline|
  ReviewApp.create!(
    Array.new(DYNO_COUNT) { review_app_attributes(pipeline) }
  )
end
