# frozen_string_literal: true

class ReviewApp < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :pipeline
  belongs_to :current_size, class_name: 'DynoSize'

  has_secure_token :log_token

  validates :app_id, presence: true

  scope :recent_first, -> { order(last_active_at: :desc) }

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
