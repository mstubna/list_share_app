require 'rails_helper'

RSpec.describe Collaboration, type: :model do
  it_behaves_like 'an ActiveRecord model'

  describe 'schema' do
    describe 'columns' do
      describe 'user_id' do
        example do
          expect(subject).to have_db_column(:user_id)
            .of_type(:integer)
        end
      end

      describe 'list_id' do
        example do
          expect(subject).to have_db_column(:user_id)
            .of_type(:integer)
        end
      end
    end

    describe 'indices' do
      describe 'user_id' do
        example do
          expect(subject).to have_db_index(:user_id)
        end
      end

      describe 'list_id' do
        example do
          expect(subject).to have_db_index(:list_id)
        end
      end

      describe 'user_id, list_id' do
        example do
          expect(subject).to have_db_index([:user_id, :list_id])
            .unique(true)
        end
      end
    end
  end

  describe 'associations' do
    describe 'user' do
      example do
        expect(subject).to belong_to(:user)
          .class_name('User')
      end
    end

    describe 'list' do
      example do
        expect(subject).to belong_to(:list)
          .class_name('List')
      end
    end
  end
end
