# frozen_string_literal: true

require 'rails_helper'

feature 'user can create question', "
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create question
" do
  describe 'authenticated user' do
    given(:user) { create(:user) }
    given(:gist_url) { 'https://gist.github.com/Vason-err/ebf797de8d60c832da5a00023a9ea20f' }
    given(:google_url) { 'https://www.google.com/' }

    background { login(user) }

    background { visit new_question_path }

    context 'with valid params' do
      background do
        fill_in 'Title', with: 'Question title'
        fill_in 'Body', with: 'Question body'
      end

      scenario 'tries to create question' do
        click_on 'Ask'

        expect(page).to have_content 'The question has been successfully created'
        expect(page).to have_content 'Question title'
        expect(page).to have_content 'Question body'
      end

      scenario 'asks a question with attached files' do
        attach_file 'File', [
          "#{Rails.root}/spec/fixtures/files/text_test_file.txt",
          "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg"
        ]
        click_on 'Ask'

        expect(page).to have_link 'text_test_file.txt'
        expect(page).to have_link 'image_test_file.jpeg'
      end

      scenario 'assigns an award for the best answer' do
        fill_in 'Reward title', with: 'Test reward'
        attach_file 'Reward file', "#{Rails.root}/spec/fixtures/files/thumb.png"
        click_on 'Ask'

        expect(page).to have_content 'Test reward'
        expect(page).to have_link 'thumb.png'
      end

      scenario 'User adds links when asks question', js: true do
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

        click_on 'Ask'
        page.reset!
        expect(page).to have_content 'gist for qna'
        expect(page).to have_link 'Google', href: google_url
      end
    end

    context 'with invalid params' do
      scenario 'tries to create invalid question' do
        click_on 'Ask'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end

    context 'multiple sessions', js: true do
      scenario "question appears on another user's page" do
        Capybara.using_session('user') do
          login(user)
          visit new_question_path
        end

        Capybara.using_session('guest') do
          visit questions_path
        end

        Capybara.using_session('user') do
          fill_in 'Title', with: 'Question title'
          fill_in 'Body', with: 'Question body'
          click_on 'Ask'

          expect(page).to have_content 'Question title'
          expect(page).to have_content 'Question body'
        end

        Capybara.using_session('guest') do
          expect(page).to have_content 'Question title'
        end
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'tries to ask a question' do
      visit questions_path

      expect(page).to_not have_link 'Ask question'
    end
  end
end
