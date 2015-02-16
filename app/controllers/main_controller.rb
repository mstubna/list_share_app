class MainController < ApplicationController
  def index
    return unless user_signed_in?
    redirect_to user_lists_path(current_user)
  end
end
