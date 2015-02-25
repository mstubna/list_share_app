class ListsController < ApplicationController
  include Concerns::UserAuthorizable

  respond_to :html, :js

  before_action do
    authenticate_user!
    @user = User.find_by_id params[:user_id]
  end
  before_action :authorize_user!, only: [:index, :new, :create, :destroy]
  before_action :authorize_own_or_shared_lists, only: [:show, :edit, :update]
  before_action :find_list, only: [:show, :edit, :update, :destroy]

  def index
    @lists = @user.all_lists.sort! { |x, y| y.updated_at <=> x.updated_at }
  end

  def new
    @list = @user.lists.build
  end

  def create
    @list = @user.lists.build(list_params)
    @list.save!
  end

  def update
    @list.update_attributes(list_params)
  end

  def destroy
    flash[:notice] = I18n.t('controllers.list.list_deleted') if @list.destroy
    redirect_to user_lists_path(@user)
  end

  private

  def find_list
    @list = List.find_by_id(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :body)
  end
end
