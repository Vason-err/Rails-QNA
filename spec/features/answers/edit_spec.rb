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
    given(:gist_url) { 'https://gist.github.com/Vason-err/ebf797de8d60c832da5a00023a9ea20f' }
    given(:google_url) { 'https://www.google.com/' }

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

    scenario 'add files' do
      click_on 'Edit answer'

      within "#edit-answer-form-#{answer.id}" do
        attach_file 'File', [
          "#{Rails.root}/spec/fixtures/files/text_test_file.txt",
          "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg",
        ]
        click_on 'Save'
      end

      within "#answer-id-#{answer.id}" do
        expect(page).to have_link 'text_test_file.txt'
        expect(page).to have_link 'image_test_file.jpeg'
      end
    end

    scenario 'can adds links' do
      click_on 'Edit answer'

      within "#edit-answer-form-#{answer.id}" do
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
      end
      wait_for_ajax
      within "#answer-id-#{answer.id}" do
        expect(page).to have_content 'gist for qna'
        expect(page).to have_link 'Google', href: google_url
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