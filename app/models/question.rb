class Question < ApplicationRecord
  belongs_to :user

  has_many :answers, -> { order('best DESC, created_at') }, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  has_many_attached :files
  has_one :reward, dependent: :destroy

  validates :title, :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank
end
