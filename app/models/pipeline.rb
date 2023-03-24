# frozen_string_literal: true

class Pipeline < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  validates :uuid, presence: true
  validates :api_key, presence: true

  belongs_to :base_size, class_name: 'DynoSize'
  belongs_to :boost_size, class_name: 'DynoSize'

  validates :base_size, inclusion: { in: DynoSize.base_sizes }
  validates :boost_size, inclusion: { in: DynoSize.boost_sizes }

  has_many :dynos, dependent: :destroy
  belongs_to :user
end
