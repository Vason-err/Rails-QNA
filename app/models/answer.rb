class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true

  def mark_as_best
    Answer.transaction do
      question.answers.update_all(best:false)
      update!(best: true)
    end
  end
end
