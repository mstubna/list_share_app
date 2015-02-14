class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    return if @user == current_user
    redirect_to root_path, alert: I18n.t('controllers.user.unauthorized')
  end
end
