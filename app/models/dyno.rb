# frozen_string_literal: true

class Dyno < ApplicationRecord
  belongs_to :pipeline
  has_secure_token :log_token

  validates :app_id, presence: true

  def self.authenticate(given_log_token)
    Dyno.find_by(log_token: given_log_token)
  end

  def request_received
    update_column(:last_active_at, DateTime.now)
  end

  def logs_url
    "https://username:#{log_token}@#{Rails.configuration.x.log_drain.hostname}/logs"
  end
end