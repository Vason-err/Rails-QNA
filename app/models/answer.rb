# frozen_string_literal: true

class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many_attached :files
  has_many :links, dependent: :destroy, as: :linkable

  validates :body, presence: true

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
