require 'rails_helper'

RSpec.describe CollaborationsController, type: :controller do
  it_behaves_like 'an Application controller'

  shared_examples_for 'a collaborations controller' do
    it "the response content type should be 'text/javascript'" do
      expect(response.content_type.to_s).to eq Mime::Type.lookup_by_extension(:js).to_s
    end
  end

  context 'when the user is signed in' do
    let(:list) { Fabricate(:list_for_user) }
    let(:another_user) { Fabricate(:user) }
    before(:each) { sign_in list.user }

    context 'for a list the user owns' do
      describe 'actions' do
        describe '#index' do
          include_examples 'a collaborations controller' do
            before { xhr :get, :index, list_id: list.id, format: :js }
          end
        end

        describe '#create' do
          context 'for a valid user email' do
            let(:attr) do
              { user: another_user.email }
            end
            include_examples 'a collaborations controller' do
              before { xhr :post, :create, list_id: list.id, collaboration: attr, format: :js }
              it 'should create a list collaboration' do
                expect(list.collaborations.length).to eq(1)
              end
              it 'should create a shared list for the other user' do
                expect(another_user.all_lists.length).to eq(1)
              end
            end
          end

          context 'for an invalid user email' do
            let(:attr) do
              { user: 'an invalid email' }
            end
            include_examples 'a collaborations controller' do
              before { xhr :post, :create, list_id: list.id, collaboration: attr, format: :js }
              it 'should not create a list collaboration' do
                expect(list.collaborations.length).to eq(0)
              end
            end
          end

          context "for the user's email" do
            let(:attr) do
              { user: 'an invalid email' }
            end
            include_examples 'a collaborations controller' do
              before { xhr :post, :create, list_id: list.id, collaboration: attr, format: :js }
              it 'should not create a list collaboration' do
                expect(list.collaborations.length).to eq(0)
              end
              it 'should not assign the user any more shared lists' do
                expect(list.user.lists.length).to eq(list.user.all_lists.length)
              end
            end
          end

          context 'for the email of a user who is already a list collaborator' do
            let(:collaboration) { Fabricate(:collaboration, list: list, user: another_user) }
            let(:attr) do
              { user: another_user.email }
            end
            include_examples 'a collaborations controller' do
              before { xhr :post, :create, list_id: list.id, collaboration: attr, format: :js }
              it 'should not create a list collaboration' do
                expect(list.collaborations.length).to eq(1)
              end
            end
          end
        end

        describe '#destroy' do
          let(:collaboration) { Fabricate(:collaboration, list: list, user: another_user) }
          include_examples 'a collaborations controller' do
            before { xhr :post, :destroy, id: collaboration.id, format: :js }
            it 'should delete the collaboration' do
              expect(list.collaborations.length).to eq(0)
            end
          end
        end
      end
    end
  end
end
