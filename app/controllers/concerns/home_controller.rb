# frozen_string_literal: true

class HomeController < ApplicationController
  skip_authorization_check

  def index; end
end
