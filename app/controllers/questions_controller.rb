class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :update, :destroy]
  before_action :find_question, only: [:show, :update, :destroy]
  before_action :check_question_author, only: [:update, :destroy]

  def index
    @questions = Question.all
  end

  def show
    @answer = @question.answers.new
  end

  def new
    @question = Question.new
    @question.build_reward
  end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: "The question has been successfully created"
    else
      render :new
    end
  end

  def update
    @notice = "The question has been successfully updated" if @question.update(question_params)
  end

  def destroy
      @question.destroy
      redirect_to questions_path, notice: "The question has been successfully deleted"
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, files: [], links_attributes: [:name, :url, :_destroy], reward_attributes: %i[title file])
  end

  def find_question
    @question = Question.with_attached_files.find(params[:id])
  end

  def check_question_author
    unless current_user.author_of?(@question)
      head(:forbidden)
    end
  end
end
