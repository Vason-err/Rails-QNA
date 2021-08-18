require 'rails_helper'

feature 'user can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to create question
} do
  describe 'authenticated user' do
    given(:user) { create(:user) }

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
          "#{Rails.root}/spec/fixtures/files/image_test_file.jpeg",
        ]
        click_on 'Ask'

        expect(page).to have_link 'text_test_file.txt'
        expect(page).to have_link 'image_test_file.jpeg'
      end
    end

    context 'with invalid params' do
      scenario 'tries to create invalid question' do
        click_on 'Ask'

        expect(page).to have_content "Title can't be blank"
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'tries to ask a question' do
      visit questions_path

      click_on 'Ask question'

      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  end
end