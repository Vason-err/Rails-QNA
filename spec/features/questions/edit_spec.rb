require 'rails_helper'

feature 'user can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like ot be able to edit my question
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe 'authenticated user', js: true do
    background { login(user) }

    background { visit question_path(question) }

    scenario 'edits his question' do
      click_on 'Edit question'

      within '.edit-question-form' do
        fill_in 'Body', with: 'New body'
        click_on 'Save'
      end

      expect(page).to have_content 'The question has been successfully updated'

      expect(page).to_not have_content question.body
      expect(page).to have_content 'New body'
      expect(page).to have_content 'Edit question'
    end

    scenario 'edits his question with errors' do
      click_on 'Edit question'

      within '.edit-question-form' do
        fill_in 'Body', with: nil
        click_on 'Save'
      end

      expect(page).not_to have_content 'The question has been successfully updated'

      expect(page).to have_content question.body
      expect(page).to have_content "Body can't be blank"
      expect(page).not_to have_content 'Edit question'
    end

    context "when user is not question's author" do
      given!(:question) { create(:question) }

      scenario "tries to edit other user's question" do
        expect(page).to_not have_link 'Edit question'
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'can not edit question' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit question'
    end
  end
end