class AnswersController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :find_question, only: [:create]
  before_action :find_answer, only: [:destroy]

  def create
    @answer = @question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to @question, notice: "The answer has been successfully created"
    else
      render 'questions/show'
    end
  end

  def destroy
    question = @answer.question

    if current_user.author_of?(@answer)
      @answer.destroy
      redirect_to question, notice: "The answer has been successfully deleted"
    else
      redirect_to question, alert: "You can't delete the answer, because you aren't its author"
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
