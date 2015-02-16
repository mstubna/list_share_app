class ListsController < ApplicationController
  include Concerns::UserAuthorizable

  before_action do
    authenticate_user!
    authorize_user! params[:user_id]
  end

  def index
    @lists = @user.lists.order('updated_at DESC')
  end

  def show
    @list = @user.lists.find_by_id(params[:id])
  end

  def new
  end

  def create
    list = @user.lists.build(list_params)
    flash[:notice] = I18n.t('controllers.list.new_list_created') if list.save!
    redirect_to user_lists_path(@user)
  end

  def edit
    @list = @user.lists.find_by_id(params[:id])
  end

  def update
    @list = @user.lists.find_by_id(params[:id])
    if @list.update_attributes(list_params)
      flash[:notice] = I18n.t('controllers.list.list_updated')
    end
    redirect_to user_lists_path(@user)
  end

  def destroy
    list = @user.lists.find_by_id(params[:id])
    flash[:notice] = I18n.t('controllers.list.list_deleted') if list.destroy
    redirect_to user_lists_path(@user)
  end

  def list_params
    params.require(:list).permit(:title, :body)
  end
end
