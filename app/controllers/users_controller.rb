class UsersController < ApplicationController
  before_filter :authenticate_user!

  def show
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to root_path, :alert => I18n.t('controllers.user.unauthorized')
    end
  end

end
