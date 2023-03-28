# frozen_string_literal: true

class ReviewApp < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  belongs_to :pipeline
  belongs_to :base_size, class_name: 'DynoSize'
  belongs_to :boost_size, class_name: 'DynoSize'
  belongs_to :current_size, class_name: 'DynoSize'

  has_secure_token :log_token

  validates :app_id, presence: true
  validates :base_size, inclusion: { in: DynoSize.all }
  validates :boost_size, inclusion: { in: DynoSize.all }

  before_validation :denormalize_dyno_sizes
  before_create :set_last_active_at

  scope :recent_first, -> { order(last_active_at: :desc) }
  scope :active, -> { where(last_active_at: 30.minutes.ago..) }
  scope :inactive, -> { where(last_active_at: ..30.minutes.ago) }
  scope :requires_upgrade, -> { active.where(arel_table[:current_size_id].not_eq(arel_table[:boost_size_id])) }
  scope :requires_downgrade, -> { inactive.where(arel_table[:current_size_id].not_eq(arel_table[:base_size_id])) }
  scope :awaiting_update, -> { where(current_size_id: nil).or(requires_upgrade).or(requires_downgrade) }

  def self.authenticate(given_log_token)
    find_by(log_token: given_log_token)
  end

  def request_received
    update_column(:last_active_at, DateTime.now)

    FormationUpdateJob.perform_async(id) if inadaquate_size?
  end

  def logs_url
    "https://username:#{log_token}@#{Rails.configuration.x.log_drain.hostname}/logs"
  end

  def optimal_size?
    current_size == optimal_size
  end

  def inadaquate_size?
    !optimal_size?
  end

  def optimal_size
    return boost_size if last_active_at > 30.minutes.ago

    base_size
  end

  private

  def denormalize_dyno_sizes
    return if pipeline.blank?

    self.base_size ||= pipeline.base_size
    self.boost_size ||= pipeline.boost_size
  end

  def set_last_active_at
    self.last_active_at ||= DateTime.now
  end
end
