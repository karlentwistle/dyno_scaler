# frozen_string_literal: true

class Organisation < ApplicationRecord
  resourcify

  validates :name, presence: true
  validates :hosted_domain, presence: true, uniqueness: true

  has_many :users, dependent: :destroy
  has_many :pipelines, dependent: :destroy
end
