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
    given(:google_url) { 'https://www.google.com/' }
    given(:gist_url) { 'https://gist.github.com/Vason-err/ebf797de8d60c832da5a00023a9ea20f' }

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

    scenario 'add files' do
      click_on 'Edit question'

      within '.edit-question-form' do
        attach_file 'File', [
          "#{Rails.root}/spec/fixtures/files/text_test_file.txt",
          "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg",
        ]
        click_on 'Save'
      end

      expect(page).to have_link 'text_test_file.txt'
      expect(page).to have_link 'image_test_file.jpeg'
    end

    scenario 'can add links' do
      click_on 'Edit question'

      within '.edit-question-form' do
        click_on 'add link'
        within '.nested-fields:last-of-type' do
          fill_in 'Link name', with: 'Google'
          fill_in 'Url', with: google_url
        end
        click_on 'add link'
        within '.nested-fields:last-of-type' do
          fill_in 'Link name', with: 'My gist'
          fill_in 'Url', with: gist_url
        end

        click_on 'Save'

        expect(page).to have_link 'Google', href: google_url
        expect(page).to have_content 'gist for qna'
      end
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