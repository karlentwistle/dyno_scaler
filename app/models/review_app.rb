# frozen_string_literal: true

class ReviewApp < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :pipeline
  belongs_to :current_size, class_name: 'DynoSize'

  has_secure_token :log_token

  validates :app_id, presence: true

  scope :recent_first, -> { order(last_active_at: :desc) }

  scope :requires_upgrade, lambda {
    joins(:pipeline)
      .where(last_active_at: 30.minutes.ago..)
      .where('review_apps.current_size_id != pipelines.boost_size_id')
  }
  scope :requires_downgrade, lambda {
    joins(:pipeline)
      .where(last_active_at: ..30.minutes.ago)
      .where('review_apps.current_size_id != pipelines.base_size_id')
  }
  scope :awaiting_update, lambda {
    joins(:pipeline)
      .where(current_size_id: nil)
      .or(requires_upgrade)
      .or(requires_downgrade)
  }

  def self.authenticate(given_log_token)
    find_by(log_token: given_log_token)
  end

  def request_received
    update_column(:last_active_at, DateTime.now)
  end

  def logs_url
    "https://username:#{log_token}@#{Rails.configuration.x.log_drain.hostname}/logs"
  end

  def optimal_size
    return pipeline.boost_size if last_active_at > 30.minutes.ago

    pipeline.base_size
  end
end
