# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Voteable

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end
end
