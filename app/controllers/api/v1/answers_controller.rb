module Api
  module V1
    class AnswersController < BaseController
      before_action :find_question, only: [:index, :create]
      before_action :find_answer, only: [:show, :update, :destroy]

      load_and_authorize_resource

      def index
        render json: @question.answers
      end

      def show
        render json: @answer, serializer: SingleAnswerSerializer
      end

      def create
        @answer = @question.answers.new(answer_params)
        @answer.user = current_resource_owner

        if @answer.save
          render json: @answer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @answer.update(answer_params)
          render json: @answer, serializer: SingleAnswerSerializer
        else
          render json: { errors: @answer.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @answer.destroy
        render json: { success: true }
      end

      private

      def answer_params
        params.require(:answer).permit(:body)
      end

      def find_question
        @question = Question.find(params[:question_id])
      end

      def find_answer
        @answer = Answer.with_attached_files.find(params[:id])
      end
    end
  end
end