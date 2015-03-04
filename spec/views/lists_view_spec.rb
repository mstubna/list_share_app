require 'rails_helper'

RSpec.describe 'lists/index.html.erb', type: :view do
  subject { rendered }

  shared_examples_for 'a list view' do
    it { is_expected.to have_link('New List', href: new_list_path) }
  end

  context 'when the user has no lists' do
    include_examples 'a list view' do
      let(:user) { Fabricate(:user) }
      before do
        allow(view).to receive_messages(current_user: user)
        assign :lists, user.all_lists
        render
      end
      it { is_expected.not_to have_selector('.list-row') }
    end
  end

  context 'when the user has lists' do
    include_examples 'a list view' do
      let(:user) { Fabricate(:user_with_lists) }
      before do
        allow(view).to receive_messages(current_user: user)
        assign :lists, user.all_lists
        render
      end
      it { is_expected.to have_selector('.list-row', count: user.lists.length) }
    end
  end

  context 'when the user has shared one list' do
    include_examples 'a list view' do
      let(:user) { Fabricate(:user_with_lists) }
      let(:another_user) { Fabricate(:user) }
      before do
        Fabricate(:collaboration, user: another_user, list: user.lists[0])
        allow(view).to receive_messages(current_user: user)
        assign :lists, user.all_lists
        render
      end
      it { is_expected.to have_content('shared with', count: 1) }
      it { is_expected.to have_selector('.list-collaborator', count: 1) }
    end
  end

  context 'when the user has had one list shared with them' do
    include_examples 'a list view' do
      let(:user) { Fabricate(:user) }
      let(:another_user) { Fabricate(:user_with_lists) }
      before do
        Fabricate(:collaboration, user: user, list: another_user.lists[0])
        allow(view).to receive_messages(current_user: user)
        assign :lists, user.all_lists
        render
      end
      it { is_expected.to have_content('shared by', count: 1) }
      it { is_expected.to have_selector('.list-owner', count: 1) }
    end
  end
end
