# frozen_string_literal: true

require 'faker'

PIPELINE_COUNT = 2
DYNO_COUNT = 10 # per pipeline

def pipeline_attributes(user)
  {
    uuid: Faker::Internet.uuid,
    api_key: Faker::Internet.uuid,
    user:
  }
end

def dyno_attributes(pipeline)
  {
    app_id: Faker::Internet.uuid,
    pipeline:
  }
end

admin = User.create!(
  email: 'admin@example.org',
  password: '12345678',
  admin: true
)

pipelines = Pipeline.create!(
  Array.new(PIPELINE_COUNT) { pipeline_attributes(admin) }
)

pipelines.each do |pipeline|
  Dyno.create!(
    Array.new(DYNO_COUNT) { dyno_attributes(pipeline) }
  )
end
