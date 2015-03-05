module Concerns
  module UserAuthorizable
    extend ActiveSupport::Concern

    included do
      # restricts a user to accessing only their data
      def authorize_user!
        return if !@user.nil? && @user == current_user
        redirect_to root_path, alert: I18n.t('controllers.user.unauthorized')
      end

      # restrics a user to accessing only their own lists
      def authorize_own_lists
        authorize_lists current_user.lists
      end

      # restrics a user to accessing their own lists
      # or lists that have been shared with them
      def authorize_own_or_shared_lists
        authorize_lists current_user.all_lists
      end

      def authorize_lists(lists)
        return if lists.map(&:id).include? params[:id].to_i
        redirect_to root_path, alert: I18n.t('controllers.user.unauthorized')
      end

      # restricts a user to accessing only collaborations belonging to their lists
      def authorize_own_list_collaborations
        render_alert(I18n.t('controllers.user.unauthorized')) unless users_list?(params[:list_id])
      end

      # restricts a user to accessing only their own collaborations
      # or collaborations belonging to their list
      def authorize_own_collaborations
        render_alert(I18n.t('controllers.user.unauthorized')) unless users_collaboration?(params[:id]) || users_list_collaboration?(params[:id])
      end

      def users_list?(list_id)
        current_user.lists.map(&:id).include? list_id.to_i
      end

      def users_collaboration?(collaboration_id)
        current_user.collaborations.map(&:id).include? collaboration_id.to_i
      end

      def users_list_collaboration?(collaboration_id)
        current_user.lists.map(&:collaborations).flatten.map(&:id).include? collaboration_id.to_i
      end
    end
  end
end
