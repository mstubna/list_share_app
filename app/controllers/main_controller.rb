class MainController < ApplicationController
  def index
    return unless user_signed_in?
    redirect_to lists_path
  end
end
