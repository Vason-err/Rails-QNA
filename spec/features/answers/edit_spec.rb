require 'rails_helper'

feature 'user can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user', js: true do
    background { login(user) }

    background { visit question_path(question) }

    scenario 'edits his answer' do
      click_on 'Edit answer'

      within "#edit-answer-form-#{answer.id}" do
        fill_in 'Body', with: 'New body'
        click_on 'Save'
      end

      expect(page).to have_content "The answer has been successfully updated"

      within "#answer-id-#{answer.id}" do
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'New body'
        expect(page).to have_content 'Edit answer'
      end
    end

    scenario 'edits his answer with errors' do
      click_on 'Edit answer'

      within "#edit-answer-form-#{answer.id}" do
        fill_in 'Body', with: nil
        click_on 'Save'
      end

      expect(page).not_to have_content "The answer has been successfully updated"

      within "#answer-id-#{answer.id}" do
        expect(page).to have_content answer.body
        expect(page).to have_content "Body can't be blank"
        expect(page).not_to have_content 'Edit answer'
      end
    end

    context "when user is not answer's author" do
      given!(:answer) { create(:answer, question: question) }

      scenario "tries to edit other user's answer" do
        expect(page).to_not have_link 'Edit answer'
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'can not edit question' do
      visit question_path(question)

      expect(page).to_not have_link 'Edit answer'
    end
  end
end