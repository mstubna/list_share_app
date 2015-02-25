module Concerns
  module UserAuthorizable
    extend ActiveSupport::Concern

    included do
      # restricts a user to accessing only their data
      def authorize_user!
        return if !@user.nil? && @user == current_user
        redirect_to root_path, alert: I18n.t('controllers.user.unauthorized')
      end

      # restrics a user to accessing only their own lists, or lists that have been shared with them
      def authorize_own_or_shared_lists
        return if current_user.all_lists.map(&:id).include? params[:id].to_i
        redirect_to root_path, alert: I18n.t('controllers.user.unauthorized')
      end
    end
  end
end
