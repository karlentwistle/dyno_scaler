# frozen_string_literal: true

class Organisation < ApplicationRecord
  validates :name, presence: true
  validates :hosted_domain, presence: true

  has_many :users, dependent: :destroy
end
