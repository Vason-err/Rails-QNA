# frozen_string_literal: true

class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: %i[create index]
  before_action :find_answer, only: %i[update destroy mark_as_best]

  authorize_resource

  def index
    @answers = @question.answers
  end

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      @notice = 'The answer has been successfully created'
    else
      @alert = 'The answer has not been created'
    end
    publish_answer
  end

  def update
    @notice = 'The answer has been successfully updated' if @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    @notice = 'The answer has been successfully deleted'
  end

  def mark_as_best
    @answer.mark_as_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: %i[name url _destroy])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def publish_answer
    return if @answer.errors.present?

    ActionCable.server.broadcast(
      "questions/#{@answer.question_id}/answers",
      {
        id: @answer.id,
        author_id: @answer.user_id,
        templates: {
          answer: render_template(
            partial: 'websockets/answers/answer',
            locals: { answer: @answer }
          ),
          vote_links: render_template(
            partial: 'websockets/shared/votes/vote_links',
            locals: { voteable: @answer, vote: @answer.votes.new }
          )
        }
      }
    )
  end
end
