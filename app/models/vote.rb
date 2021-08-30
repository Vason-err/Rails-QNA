class Vote < ApplicationRecord
  POSITIVE = 1.freeze
  NEGATIVE = -1.freeze
  VALUES = [POSITIVE, NEGATIVE].freeze

  belongs_to :user
  belongs_to :voteable, polymorphic: true

  validates :value, presence: true, inclusion: { in: VALUES }
  validates :user_id, uniqueness: { scope: [:voteable_type, :voteable_id] }
end
