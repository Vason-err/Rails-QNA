class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  validates :text, presence: true

  def ws_stream_name
    case commentable_type
    when 'Question' then "questions/#{commentable_id}/comments"
    when 'Answer' then "questions/#{commentable.question_id}/comments"
    else nil
    end
  end
end
