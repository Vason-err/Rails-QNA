class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_commentable, only: :create

  after_action :publish_comment, only: [:create]

  def create
    @comment = @commentable.comments.new(user: current_user, text: comment_params[:text])

    if @comment.save
      render json: @comment
    else
      render json: { errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_commentable
    @commentable = params[:commentable_type].classify.constantize.find(params[:commentable_id])
  end

  def comment_params
    params.require(:comment)
  end

  def publish_comment
    return if @comment.errors.present?

    ActionCable.server.broadcast(
      @comment.ws_stream_name,
      {
        author_id: @comment.user_id,
        answer_id: @comment.commentable_type == 'Answer' ? @comment.commentable_id : nil,
        template: render_template(
          partial: 'websockets/comments/comment',
          locals: { comment: @comment }
        )
      }
    )
  end
end
