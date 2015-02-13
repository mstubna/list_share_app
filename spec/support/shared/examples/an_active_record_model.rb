RSpec.shared_examples 'an ActiveRecord model' do
  example { expect(subject).to be_an(ActiveRecord::Base) }

  describe 'schema' do
    describe 'columns' do
      describe 'created_at' do
        example do
          expect(subject).to have_db_column(:created_at)
            .of_type(:datetime)
            .with_options(
              null: true,
              default: nil
            )
        end

        describe 'id' do
          example do
            expect(subject).to have_db_column(:id)
              .of_type(:integer)
              .with_options(
                null: false,
                limit: 4
              )
          end
        end

        describe 'updated_at' do
          example do
            expect(subject).to have_db_column(:updated_at)
              .of_type(:datetime)
              .with_options(
                null: true,
                default: nil
              )
          end
        end
      end
    end
  end
end
