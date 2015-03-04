require 'rails_helper'

RSpec.describe 'main/index.html.erb', type: :view do
  subject { rendered }
  before { render }
  it { is_expected.to have_link('Sign Up', href: new_user_registration_path) }
  it { is_expected.to have_link('Sign In', href: new_user_session_path) }
end
