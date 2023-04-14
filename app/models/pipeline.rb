# frozen_string_literal: true

class Pipeline < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  validates :uuid, presence: true
  validates :api_key, presence: true

  belongs_to :base_size, class_name: 'DynoSize'
  belongs_to :boost_size, class_name: 'DynoSize'

  validates :base_size, inclusion: { in: DynoSize.base_sizes }
  validates :boost_size, inclusion: { in: DynoSize.boost_sizes }
  validates :name, presence: true

  has_many :review_apps, dependent: :destroy
  belongs_to :organisation

  before_validation :fetch_pipeline_info

  after_update :sync_denormalized_data

  def platform_api
    @platform_api ||= PlatformAPI.connect_oauth(api_key)
  end

  private

  def fetch_pipeline_info
    self.name ||= PlatformAPI::Pipeline.new(platform_api).info(uuid).fetch('name')
  rescue Excon::Error::Unauthorized
    errors.add(:api_key, 'is invalid')
  rescue Excon::Error::NotFound
    errors.add(:uuid, 'is invalid')
  end

  def sync_denormalized_data
    review_apps.update_all(base_size_id:, boost_size_id:)
  end
end
