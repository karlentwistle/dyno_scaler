class Pipeline < ApplicationRecord
  validates :uuid, presence: true
  validates :api_key, presence: true
end
