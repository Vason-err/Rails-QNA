require 'rails_helper'

feature 'user can sign in', %q{
  In order to ask questions
  As an unauthenticated user
  I'd like to be able to sign in
} do
  background { visit new_user_session_path }

  describe 'registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign in' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_on 'Log in'

      expect(page).to have_content('Signed in successfully.')
    end
  end

  describe 'unregistered user' do
    scenario 'tries to sign in' do
      fill_in 'Email', with: 'wrong_email@test.com'
      fill_in 'Password', with: 'wrong_password'
      click_on 'Log in'

      expect(page).to have_content('Invalid Email or password.')
    end
  end
end