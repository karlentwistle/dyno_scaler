# frozen_string_literal: true

class User < ApplicationRecord
  include Clearance::User

  has_many :pipelines, dependent: :destroy

  belongs_to :organisation

  def self.find_or_create_from_auth_hash(auth_hash)
    organisation = Organisation.find_by!(hosted_domain: auth_hash.extra.raw_info.hd)

    organisation.users.find_or_create_by!(email: auth_hash.info['email']) do |user|
      user.password = SecureRandom.hex
    end
  end
end
