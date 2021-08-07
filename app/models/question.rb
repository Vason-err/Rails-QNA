class Question < ApplicationRecord
  belongs_to :user
  has_one :best_answer, class_name: 'Answer', dependent: :nullify
  has_many :answers, dependent: :destroy

  validates :title, :body, presence: true

  def answers_without_best
    answers.where.not(id: best_answer_id)
  end
end
