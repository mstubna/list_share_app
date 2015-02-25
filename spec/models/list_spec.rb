require 'rails_helper'

RSpec.describe List, type: :model do
  it_behaves_like 'an ActiveRecord model'

  describe 'schema' do
    describe 'columns' do
      describe 'title' do
        example do
          expect(subject).to have_db_column(:title)
            .of_type(:string)
            .with_options(
              null: true,
              limit: 255
            )
        end
      end

      describe 'body' do
        example do
          expect(subject).to have_db_column(:body)
            .of_type(:text)
            .with_options(
              null: true,
              limit: 65_535
            )
        end
      end

      describe 'user_id' do
        example do
          expect(subject).to have_db_column(:user_id)
            .of_type(:integer)
            .with_options(
              null: false,
              limit: 4
            )
        end
      end
    end

    describe 'indices' do
      describe 'user_id' do
        example do
          expect(subject).to have_db_index(:user_id)
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

    describe 'collaborations' do
      example do
        expect(subject).to have_many(:collaborations)
          .class_name('Collaboration')
      end
    end

    describe 'collaborators' do
      example do
        expect(subject).to have_many(:collaborators)
          .class_name('User')
          .with_foreign_key('user_id')
          .dependent(:destroy)
      end
    end
  end
end
