# frozen_string_literal: true

class User < ApplicationRecord
  rolify
  include Clearance::User

  has_many :pipelines, dependent: :destroy

  belongs_to :organisation

  after_create :assign_default_role

  def self.find_or_create_from_auth_hash(auth_hash)
    email = auth_hash.info['email']
    hosted_domain = auth_hash.extra.raw_info.hd

    raise ActiveRecord::RecordNotFound if email.blank? || hosted_domain.blank?

    organisation = Organisation.find_by!(hosted_domain:)
    organisation.users.find_or_create_by!(email:) { |u| u.password = SecureRandom.hex }
  end

  private

  def assign_default_role
    add_role(:viewer, organisation)
  end
end
