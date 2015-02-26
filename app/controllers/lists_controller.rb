class ListsController < ApplicationController
  include Concerns::UserAuthorizable

  respond_to :html, :js

  before_action do
    authenticate_user!
  end
  before_action :authorize_own_or_shared_lists, only: [:show, :edit, :update]
  before_action :authorize_own_lists, only: :destroy
  before_action :find_list, only: [:show, :edit, :update, :destroy]

  def index
    @lists = current_user.all_lists.sort! { |x, y| y.updated_at <=> x.updated_at }
  end

  def new
    @list = current_user.lists.build
  end

  def create
    @list = current_user.lists.build(list_params)
    @list.save!
  end

  def update
    @list.update_attributes(list_params)
  end

  def destroy
    flash[:notice] = I18n.t('controllers.list.list_deleted') if @list.destroy
    redirect_to root_path
  end

  private

  def find_list
    @list = List.find_by_id(params[:id])
  end

  def list_params
    params.require(:list).permit(:title, :body)
  end
end
