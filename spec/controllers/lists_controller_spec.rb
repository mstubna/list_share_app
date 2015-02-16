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
        before { get :new, user_id: list.user.id }
        it { is_expected.to render_template('lists/new') }
        it { is_expected.to render_with_layout('application') }
      end

      describe '#create' do
        let(:attr) do
          { title: 'new title', body: 'new body text' }
        end
        before { post :create, user_id: list.user.id, id: list.id, list: attr }
        it { is_expected.to redirect_to(user_lists_path) }
        it { is_expected.to set_flash[:notice].to(I18n.t('controllers.list.new_list_created')) }
      end

      describe '#edit' do
        before { get :edit, user_id: list.user.id, id: list.id }
        it { is_expected.to render_template('lists/edit') }
        it { is_expected.to render_with_layout('application') }
      end

      describe '#update' do
        let(:attr) do
          { title: 'new title', body: 'new body text' }
        end
        before { post :update, user_id: list.user.id, id: list.id, list: attr }
        it { is_expected.to redirect_to(user_lists_path) }
        it { is_expected.to set_flash[:notice].to(I18n.t('controllers.list.list_updated')) }
      end

      describe '#destroy' do
        before { delete :destroy, user_id: list.user.id, id: list.id }
        it { is_expected.to redirect_to(user_lists_path) }
        it { is_expected.to set_flash[:notice].to(I18n.t('controllers.list.list_deleted')) }
      end
    end
  end
end
