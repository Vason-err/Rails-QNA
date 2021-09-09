# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include ApplicationHelper

  rescue_from CanCan::AccessDenied do |exception|
    if is_navigational_format?
      redirect_to root_url, alert: exception.message
    else
      head(:forbidden)
    end
  end

  check_authorization unless: :devise_controller?

  private

  def render_template(options)
    ApplicationController.render(options)
  end
end
