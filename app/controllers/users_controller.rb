class UsersController < ApplicationController
  include Concerns::UserAuthorizable

  before_action do
    authenticate_user!
    authorize_user! params[:id]
  end

  def show
    @user = User.find(params[:id])
  end
end
