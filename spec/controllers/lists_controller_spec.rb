require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  it_behaves_like 'an Application controller'

  context 'when the user is signed in and authorized' do
    let(:list) { Fabricate(:list) }
    before(:each) { sign_in list.user }
    describe 'actions' do
      describe '#index' do
        before { get :index, user_id: list.user.id }
        it { is_expected.to render_template('lists/index') }
        it { is_expected.to render_with_layout('application') }
      end

      describe '#show' do
        before { get :show, user_id: list.user.id, id: list.id }
        it { is_expected.to render_template('lists/show') }
        it { is_expected.to render_with_layout('application') }
      end

      describe '#new' do
        before { xhr :get, :new, user_id: list.user.id, format: :js }
        it { expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s }
      end

      describe '#create' do
        let(:attr) do
          { title: 'new title', body: 'new body text' }
        end
        before { xhr :post, :create, user_id: list.user.id, id: list.id, list: attr, format: :js }
        it { expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s }
      end

      describe '#edit' do
        before { xhr :get, :edit, user_id: list.user.id, id: list.id }
        it { expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s }
      end

      describe '#update' do
        let(:attr) do
          { title: 'new title', body: 'new body text' }
        end
        before { xhr :post, :update, user_id: list.user.id, id: list.id, list: attr }
        it { expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s }
      end

      describe '#destroy' do
        before { delete :destroy, user_id: list.user.id, id: list.id }
        it { is_expected.to redirect_to(user_lists_path) }
        it { is_expected.to set_flash[:notice].to(I18n.t('controllers.list.list_deleted')) }
      end
    end
  end
end
