class SingleAnswerSerializer < AnswerSerializer
  attributes :files

  has_many :links
  has_many :comments

  def files
    object.files.map { |f| Rails.application.routes.url_helpers.rails_blob_path(f, only_path: true) }
  end
end