require 'rails_helper'

RSpec.describe MainController, type: :controller do
  it_behaves_like 'an Application controller'

  describe 'actions' do
    describe '#index' do
      context 'When the user is not signed in' do
        before { get :index }
        it { is_expected.to render_template('main/index') }
        it { is_expected.to render_with_layout('application') }
      end

      let(:user) { Fabricate(:user) }

      context 'When the user is signed in' do
        before do
          sign_in user
          get :index
        end
        it { is_expected.to redirect_to(user_lists_path user) }
      end
    end
  end
end
