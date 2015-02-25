class UsersController < ApplicationController
  include Concerns::UserAuthorizable

  before_action do
    authenticate_user!
    @user = User.find(params[:id])
    authorize_user!
  end
end
