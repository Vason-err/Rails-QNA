require 'rails_helper'

feature 'user can delete his files' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_file, user: user) }
  given!(:file) { question.files.first }

  describe 'authenticated user', js: true do
    background { login(user) }

    background { visit question_path(question) }

    scenario 'delete his file' do
      expect(page).to have_content file.filename

      click_on 'Delete file'

      expect(page).not_to have_content file.filename
      expect(page).not_to have_link 'Delete file'
    end

    context "when user is not question's author" do
      given!(:question) { create(:question, :with_file) }

      scenario "tries to delete other user's file" do
        expect(page).to_not have_link 'Delete file'
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'can not delete file' do
      visit question_path(question)

      expect(page).to_not have_link 'Delete file'
    end
  end
end