# Preview all emails at http://localhost:3000/rails/mailers/notification
class NotificationPreview < ActionMailer::Preview
  def new_answer
    NotificationMailer.new_answer
  end
end
