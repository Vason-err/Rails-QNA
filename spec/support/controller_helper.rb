# frozen_string_literal: true

module ControllerHelper
  def login(user)
    @request.env['devise.mapping'] = Devise.mappings[:user]
    sign_in(user)
  end
end
