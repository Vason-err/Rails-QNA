class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    set_voteable
    authorize! :create_vote, @voteable

    vote = @voteable.votes.new(user: current_user, value: params[:value])

    if vote.save
      render json: vote
    else
      render json: { errors: vote.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    find_vote
    authorize! :destroy, @vote
    @vote.destroy!
    render json: @vote
  end

  private

  def set_voteable
    @voteable = voteable_type.classify.constantize.find(params[:voteable_id])
  end

  def voteable_type
    params[:voteable_type]
  end

  def find_vote
    @vote = Vote.find(params[:id])
  end
end
