class Reward < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :question

  has_one_attached :file

  validates :title, presence: true
end
