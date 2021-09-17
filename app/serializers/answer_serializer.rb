class AnswerSerializer < ApplicationSerializer
  attributes :id, :body, :created_at, :updated_at, :question_id

  belongs_to :user
end