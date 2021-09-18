# frozen_string_literal: true

class Answer < ApplicationRecord
  include Linkable
  include Voteable
  include Commentable

  belongs_to :user
  belongs_to :question

  has_many_attached :files

  after_create :send_notification

  validates :body, presence: true

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best: false)
      question.reward&.update!(user_id: user_id)
      update!(best: true)
    end
  end

  def send_notification
    NotificationService.new.new_answer(self)
  end
end
