class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :find_question, only: [:create, :index]
  before_action :find_answer, only: [:update, :destroy, :mark_as_best]
  before_action :check_answer_author, only: [:update, :destroy]

  def index
    @answers = @question.answers
  end

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
    @notice = "The answer has been successfully updated" if @answer.update(answer_params)
  end

  def destroy
    @answer.destroy
    @notice = "The answer has been successfully deleted"
  end

  def mark_as_best
    render status: :forbidden unless current_user.author_of?(@answer.question)
    @answer.mark_as_best
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def find_question
    @question = Question.find(params[:question_id])
  end

  def find_answer
    @answer = Answer.with_attached_files.find(params[:id])
  end

  def check_answer_author
    unless current_user.author_of?(@answer)
      head(:forbidden)
    end
  end
end
