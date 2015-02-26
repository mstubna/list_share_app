require 'rails_helper'

RSpec.describe ListsController, type: :controller do
  it_behaves_like 'an Application controller'

  context 'when the user is signed in' do
    let(:list) { Fabricate(:list) }
    before(:each) { sign_in list.user }
    context 'for a list the user owns' do
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
          it "the response content type should be 'text/javascript'" do
            expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s
          end
        end

        describe '#create' do
          let(:attr) do
            { title: 'new title', body: 'new body text' }
          end
          before { xhr :post, :create, user_id: list.user.id, id: list.id, list: attr, format: :js }
          it "the response content type should be 'text/javascript'" do
            expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s
          end
        end

        describe '#edit' do
          before { xhr :get, :edit, user_id: list.user.id, id: list.id }
          it "the response content type should be 'text/javascript'" do
            expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s
          end
        end

        describe '#update' do
          let(:attr) do
            { title: 'new title', body: 'new body text' }
          end
          before { xhr :post, :update, user_id: list.user.id, id: list.id, list: attr }
          it "the response content type should be 'text/javascript'" do
            expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s
          end
        end

        describe '#destroy' do
          before { delete :destroy, user_id: list.user.id, id: list.id }
          it { is_expected.to redirect_to(root_path) }
          it { is_expected.to set_flash[:notice].to(I18n.t('controllers.list.list_deleted')) }
        end
      end

      context 'for a list belonging to another user' do
        let(:new_list) { Fabricate(:list) }
        describe 'actions' do
          describe '#show' do
            before { get :show, user_id: new_list.user.id, id: new_list.id }
            it { is_expected.to redirect_to(root_path) }
            it { is_expected.to set_flash[:alert].to(I18n.t('controllers.user.unauthorized')) }
          end

          describe '#edit' do
            before { xhr :get, :edit, user_id: new_list.user.id, id: new_list.id }
            it { is_expected.to redirect_to(root_path) }
            it { is_expected.to set_flash[:alert].to(I18n.t('controllers.user.unauthorized')) }
          end

          describe '#update' do
            let(:attr) do
              { title: 'new title', body: 'new body text' }
            end
            before { xhr :post, :update, user_id: new_list.user.id, id: new_list.id, list: attr }
            it { is_expected.to redirect_to(root_path) }
            it { is_expected.to set_flash[:alert].to(I18n.t('controllers.user.unauthorized')) }
          end

          describe '#destroy' do
            before { delete :destroy, user_id: new_list.user.id, id: new_list.id }
            it { is_expected.to redirect_to(root_path) }
            it { is_expected.to set_flash[:alert].to(I18n.t('controllers.user.unauthorized')) }
          end
        end
      end
    end
  end

  context 'when a user has shared one of their lists with a second user' do
    context 'when the second user is signed in' do
      let(:list) { Fabricate(:list) }
      let(:another_user) { Fabricate(:user) }
      before(:each) do
        another_user.shared_lists << list
        sign_in another_user
      end

      describe 'actions' do
        describe '#index' do
          before { get :index, user_id: another_user.id }
          it { is_expected.to render_template('lists/index') }
          it { is_expected.to render_with_layout('application') }
          it 'should assign a local variable @lists with length 1' do
            expect(assigns(:lists).length).to be(1)
          end
        end

        describe '#show' do
          before { get :show, user_id: another_user.id, id: list.id }
          it { is_expected.to render_template('lists/show') }
          it { is_expected.to render_with_layout('application') }
        end

        describe '#update' do
          let(:attr) do
            { title: 'new title', body: 'new body text' }
          end
          before { xhr :post, :update, user_id: list.user.id, id: list.id, list: attr }
          it "the response content type should be 'text/javascript'" do
            expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s
          end
          describe 'the local variable @list' do
            it "should have title updated to 'new title'" do
              expect(assigns(:list).title).to eq('new title')
            end
            it "should have body updated to 'new body text'" do
              expect(assigns(:list).body).to eq('new body text')
            end
          end
        end

        describe '#destroy' do
          before { delete :destroy, user_id: list.user.id, id: list.id }
          it { is_expected.to redirect_to(root_path) }
          it { is_expected.to set_flash[:alert].to(I18n.t('controllers.user.unauthorized')) }
        end
      end
    end
  end
end
