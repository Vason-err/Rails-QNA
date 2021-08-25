# frozen_string_literal: true

require 'rails_helper'

feature 'user can sign up', "
  In order to ask questions
  As an unregistered user
  I'd like to be able to sign up
" do
  background { visit new_user_registration_path }

  describe 'unregistered user' do
    scenario 'tries to sign up' do
      fill_in 'Email', with: 'test@test.com'
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_on 'Sign up'

      expect(page).to have_content('Welcome! You have signed up successfully.')
    end
  end

  describe 'registered user' do
    given(:user) { create(:user) }

    scenario 'tries to sign up' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: 'password'
      fill_in 'Password confirmation', with: 'password'
      click_on 'Sign up'

      expect(page).to have_content('Email has already been taken')
    end
  end
end
