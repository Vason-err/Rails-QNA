class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  validates :title, :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank
end
