class FilesController < ApplicationController
  before_action :authenticate_user!

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])

    if current_user.author_of?(@file.record)
      @file.purge
    else
      @alert = "You can't delete the file, because you aren't its author"
    end
  end
end