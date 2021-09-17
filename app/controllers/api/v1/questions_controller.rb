module Api
  module V1
    class QuestionsController < BaseController
      before_action :find_question, only: [:show, :update, :destroy]

      load_and_authorize_resource

      def index
        questions = Question.all
        render json: questions
      end

      def show
        render json: @question, serializer: SingleQuestionSerializer
      end

      def create
        question = current_resource_owner.questions.new(question_params)

        if question.save
          render json: question
        else
          render json: { errors: question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: @question, serializer: SingleQuestionSerializer
        else
          render json: { errors: @question.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.destroy
        render json: { success: true }
      end

      private

      def question_params
        params.require(:question).permit(:title, :body)
      end

      def find_question
        @question = Question.with_attached_files.find(params[:id])
      end
    end
  end
end