# frozen_string_literal: true

class FilesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_author!

  def destroy
    file.purge
  end

  private

  helper_method :file

  def check_author!
    head(:forbidden) unless current_user&.author_of?(file.record)
  end

  def file
    @file ||= ActiveStorage::Attachment.find(params[:id])
  end
end
