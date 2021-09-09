# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    authorize! :destroy, file
    file.purge
  end

  private

  helper_method :file

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
