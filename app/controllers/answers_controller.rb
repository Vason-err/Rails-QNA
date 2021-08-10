class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:update, :destroy, :mark_as_best]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      @notice = "The answer has been successfully created"
    else
      @alert = "The answer has not been created"
    end
  end

  def update
    render status: :forbidden if !(current_user.author_of?(@answer))
    @notice = "The answer has been successfully updated" if @answer.update(answer_params)
  end

  def destroy
    if current_user.author_of?(@answer)
      @answer.destroy
      @notice = "The answer has been successfully deleted"
    else
      @alert = "You can't delete the answer, because you aren't its author"
    end
  end

  def mark_as_best
    if current_user.author_of?(@answer.question)
      @answer.mark_as_best
    else
      @alert = "You can't mark the answer, because you aren't author the question"
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.find(params[:id])
  end
end
