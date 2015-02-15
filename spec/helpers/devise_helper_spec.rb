require 'rails_helper'

RSpec.describe DeviseHelper, type: :helper do
  describe '#devise_error_messages!' do
    subject { helper.devise_error_messages! }

    # create a mock of the Devise Controller resource method
    before do
      class MockResource
        def errors
          MockError.new
        end
      end
      def helper.resource
        MockResource.new
      end
    end

    context 'When the controller.resource contains no errors' do
      class MockError
        def empty?
          true
        end
      end
      example { expect(subject).to be_nil }
    end

    context 'When the controller.resource contains an error' do
      class MockError
        def empty?
          false
        end

        def full_messages
          [{ msg: 'an error message' }]
        end
      end

      example { expect(subject).to be_nil }

      example do
        subject
        expect(helper).to set_flash[:devise_error].now
      end
    end
  end
end
