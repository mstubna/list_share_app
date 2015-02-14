require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  it_behaves_like 'an Application controller'

  describe 'actions' do
    describe '#show' do

      let(:user) { Fabricate(:user) }

      context "When the user is not signed in" do
        before { get :show, id: user.id }
        it { is_expected.to set_flash[:alert].to(I18n.t('devise.failure.unauthenticated')) }
        it { is_expected.to redirect_to(new_user_session_path) }
      end

      context "When the user is signed in" do
        before do
          sign_in user
          get :show, id: user.id
        end
        it { is_expected.to render_template('users/show') }
        it { is_expected.to render_with_layout('application') }
      end

      context "When the user is signed in but requesting another user's id" do
        let(:user_2) { Fabricate(:user) }
        before do
          sign_in user_2
          get :show, id: user.id
        end
        it { is_expected.to redirect_to(root_path) }
        it { is_expected.to set_flash[:alert].to(I18n.t('controllers.user.unauthorized'))}
      end
    end
  end
end
