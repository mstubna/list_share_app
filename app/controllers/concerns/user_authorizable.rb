module Concerns
  module UserAuthorizable
    extend ActiveSupport::Concern

    included do
      # restricts a user to accessing only their data
      def authorize_user!(id)
        @user = User.find_by_id id
        return if !@user.nil? && @user == current_user
        redirect_to root_path, alert: I18n.t('controllers.user.unauthorized')
      end
    end
  end
end
