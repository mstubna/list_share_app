class ListsController < ApplicationController
  include Concerns::UserAuthorizable

  before_action do
    authenticate_user!
    authorize_user! params[:user_id]
  end

  before_action :find_list, only: [:show, :edit]

  def index
    @lists = @user.lists.order('updated_at DESC')
  end

  def create
    list = @user.lists.build(list_params)
    flash[:notice] = I18n.t('controllers.list.new_list_created') if list.save!
    redirect_to user_lists_path(@user)
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

  private

    def find_list
      @list = @user.lists.find_by_id(params[:id])
    end

    def list_params
      params.require(:list).permit(:title, :body)
    end

end
