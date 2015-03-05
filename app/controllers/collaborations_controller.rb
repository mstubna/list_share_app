class CollaborationsController < ApplicationController
  include Concerns::UserAuthorizable

  respond_to :js

  before_action :authenticate_user!
  before_action :authorize_own_list_collaborations, only: [:index, :create]
  before_action :authorize_own_collaborations, only: :destroy

  def index
    find_list
    render_index
  end

  def create
    find_list
    user = User.find_by_email collaboration_params[:user]
    alert = check_for_create_error user
    return render_alert(alert) unless alert.nil?
    @list.collaborations.build(user: user).save!
    render_index
  end

  def destroy
    collaboration = Collaboration.find_by_id(params[:id])
    return head :bad_request if collaboration.nil?
    @list = collaboration.list
    collaboration.destroy unless collaboration.nil?
    render_index
  end

  private

  def find_list
    @list = List.find_by_id(params[:list_id])
  end

  def check_for_create_error(user)
    return I18n.t('controllers.collaboration.user_not_found') if user.nil?
    return I18n.t('controllers.collaboration.user_already_sharing') if @list.collaborators.include?(user)
    return I18n.t('controllers.collaboration.user_is_owner') if @list.user == user
  end

  def render_alert(alert)
    render partial: 'alert', locals: { alert: alert }
  end

  def render_index
    @collaborations = @list.collaborations
    @collaboration = Collaboration.new
    render 'index'
  end

  def collaboration_params
    params.require(:collaboration).permit(:user, :id)
  end
end
