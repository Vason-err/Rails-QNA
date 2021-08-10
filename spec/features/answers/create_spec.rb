require 'rails_helper'

feature 'user can create answer', %q{
  In order to help community members
  As an authenticated user
  I'd like to be able to create answer
} do
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    given(:user) { create(:user) }

    background { login(user) }

    background { visit question_path(question) }

    scenario 'tries to answer a question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Answer'

      expect(page).to have_content 'The answer has been successfully created'
      within '.answers' do
        expect(page).to have_content 'Answer body'
        expect(page).to have_content 'Edit answer'
        expect(page).to have_content 'Delete answer'
      end
    end

    scenario 'tries to create invalid answer a question' do
      click_on 'Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  describe 'unauthenticated user' do
    scenario 'tries to answer a question' do
      visit question_path(question)

      expect(page).not_to have_content 'New answer'
    end
  end
end