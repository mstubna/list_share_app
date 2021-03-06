require 'rails_helper'

RSpec.describe User, type: :model do
  it_behaves_like 'an ActiveRecord model'

  describe 'schema' do
    describe 'columns' do
      describe 'current_sign_in_at' do
        example do
          expect(subject).to have_db_column(:current_sign_in_at)
            .of_type(:datetime)
            .with_options(
              null: true,
              default: nil
            )
        end
      end

      describe 'current_sign_in_ip' do
        example do
          expect(subject).to have_db_column(:current_sign_in_ip)
            .of_type(:string)
            .with_options(
              null: true,
              default: nil,
              limit: 255
            )
        end
      end

      describe 'email' do
        example do
          expect(subject).to have_db_column(:email)
            .of_type(:string)
            .with_options(
              null: false,
              default: '',
              limit: 255
            )
        end
      end

      describe 'encrypted_password' do
        example do
          expect(subject).to have_db_column(:encrypted_password)
            .of_type(:string)
            .with_options(
              null: false,
              default: '',
              limit: 255
            )
        end
      end

      describe 'last_sign_in_at' do
        example do
          expect(subject).to have_db_column(:last_sign_in_at)
            .of_type(:datetime)
            .with_options(
              null: true,
              default: nil
            )
        end
      end

      describe 'last_sign_in_ip' do
        example do
          expect(subject).to have_db_column(:last_sign_in_ip)
            .of_type(:string)
            .with_options(
              null: true,
              default: nil,
              limit: 255
            )
        end
      end

      describe 'remember_created_at' do
        example do
          expect(subject).to have_db_column(:remember_created_at)
            .of_type(:datetime)
            .with_options(
              null: true,
              default: nil
            )
        end
      end

      describe 'reset_password_sent_at' do
        example do
          expect(subject).to have_db_column(:reset_password_sent_at)
            .of_type(:datetime)
            .with_options(
              null: true,
              default: nil
            )
        end
      end

      describe 'reset_password_token' do
        example do
          expect(subject).to have_db_column(:reset_password_token)
            .of_type(:string)
            .with_options(
              null: true,
              default: nil,
              limit: 255
            )
        end
      end

      describe 'sign_in_count' do
        example do
          expect(subject).to have_db_column(:sign_in_count)
            .of_type(:integer)
            .with_options(
              null: false,
              default: 0,
              limit: 4
            )
        end
      end
    end

    describe 'indices' do
      describe 'email' do
        example do
          expect(subject).to have_db_index(:email)
            .unique(true)
        end
      end

      describe 'reset_password_token' do
        example do
          expect(subject).to have_db_index(:reset_password_token)
            .unique(true)
        end
      end
    end
  end

  describe 'associations' do
    describe 'lists' do
      example do
        expect(subject).to have_many(:lists)
          .dependent(:destroy)
      end
    end

    describe 'collaborations' do
      example do
        expect(subject).to have_many(:collaborations)
          .class_name('Collaboration')
      end
    end

    describe 'shared_lists' do
      example do
        expect(subject).to have_many(:shared_lists)
          .class_name('List')
          .with_foreign_key('list_id')
          .dependent(:destroy)
      end
    end
  end

  describe 'devise' do
    example { expect(subject).not_to be_a(Devise::Models::Confirmable) }
    example { expect(subject).to be_a(Devise::Models::DatabaseAuthenticatable) }
    example { expect(subject).not_to be_a(Devise::Models::Lockable) }
    example { expect(subject).to be_a(Devise::Models::Registerable) }
    example { expect(subject).to be_a(Devise::Models::Recoverable) }
    example { expect(subject).to be_a(Devise::Models::Rememberable) }
    example { expect(subject).not_to be_a(Devise::Models::Timeoutable) }
    example { expect(subject).to be_a(Devise::Models::Trackable) }
    example { expect(subject).to be_a(Devise::Models::Validatable) }
  end

  describe 'methods' do
    describe 'instance' do
      describe 'all_lists' do
        subject { user.all_lists }

        describe 'when the user owns no lists' do
          describe 'when the user has no lists shared with them' do
            let(:user) { Fabricate(:user) }
            example { expect(subject).to be_empty }
          end

          describe 'when the user has a list shared with them' do
            let(:list) { Fabricate(:list_for_user) }
            let(:user) { Fabricate(:user, shared_lists: [list]) }
            example { expect(subject).to eq([list]) }
          end
        end

        describe 'when the user owns a list' do
          describe 'when the user has no lists shared with them' do
            let(:list) { Fabricate(:list_for_user) }
            let(:user) { list.user }
            example { expect(subject).to eq([list]) }
          end

          describe 'when the user has a list shared with them' do
            let(:shared_list) { Fabricate(:list_for_user) }
            let(:list) { Fabricate(:list_for_user) }
            let(:user) { list.user }
            before { user.shared_lists << shared_list }
            example { expect(subject).to eq([list, shared_list]) }
          end
        end
      end
    end
  end
end
