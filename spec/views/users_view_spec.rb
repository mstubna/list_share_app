require 'rails_helper'

RSpec.describe 'users/show.html.erb', type: :view do
  subject { rendered }

  before do
    assign :user, user
    render
  end

  let(:user) { Fabricate(:user) }

  it { is_expected.to have_content('Profile') }
  it { is_expected.to have_content("Email: #{user.email}") }
end
