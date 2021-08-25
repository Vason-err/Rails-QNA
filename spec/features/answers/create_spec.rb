# frozen_string_literal: true

require 'rails_helper'

feature 'user can create answer', "
  In order to help community members
  As an authenticated user
  I'd like to be able to create answer
" do
  given!(:question) { create(:question) }

  describe 'authenticated user', js: true do
    given(:user) { create(:user) }
    given(:gist_url) { 'https://gist.github.com/Vason-err/ebf797de8d60c832da5a00023a9ea20f' }
    given(:google_url) { 'https://www.google.com/' }

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

    scenario 'tries to create answer with attached files' do
      fill_in 'Body', with: 'Answer body'
      attach_file 'File', [
        "#{Rails.root}/spec/fixtures/files/text_test_file.txt",
        "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg"
      ]
      click_on 'Answer'

      within '.answers' do
        expect(page).to have_link 'text_test_file.txt'
        expect(page).to have_link 'image_test_file.jpeg'
      end
    end

    scenario 'User adds links when asks answer' do
      fill_in 'Body', with: 'Test answer'
      click_on 'add link'
      within '.nested-fields:last-of-type' do
        fill_in 'Link name', with: 'My gist'
        fill_in 'Url', with: gist_url
      end
      click_on 'add link'
      within '.nested-fields:last-of-type' do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end
      click_on 'Answer'
      wait_for_ajax

      within '.answers' do
        expect(page).to have_content 'gist for qna'
        expect(page).to have_link 'Google', href: google_url
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
