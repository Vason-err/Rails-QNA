# frozen_string_literal: true

class LinksController < ApplicationController
  layout false, only: %i[destroy]
  before_action :authenticate_user!

  load_and_authorize_resource

  def destroy
    @link = Link.find(params[:id])
    @link.destroy
  end
end
