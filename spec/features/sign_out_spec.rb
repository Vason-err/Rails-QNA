# frozen_string_literal: true

require 'rails_helper'

feature 'user can sign out', "
  In order to finish the job
  As an authenticated user
  I'd like to be able to sign out
" do
  given(:user) { create(:user) }

  background { login(user) }

  scenario 'authenticated user tries to sign out' do
    click_on 'Sign out'

    expect(page).to have_content('Signed out successfully.')
  end
end
