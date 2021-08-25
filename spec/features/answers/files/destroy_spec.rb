# frozen_string_literal: true

require 'rails_helper'

feature 'user can delete his files' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, :with_file, question: question, user: user) }
  given!(:file) { answer.files.first }

  describe 'authenticated user', js: true do
    background { login(user) }

    background { visit question_path(question) }

    scenario 'delete his file' do
      expect(page).to have_content file.filename

      click_on 'Delete file'

      expect(page).not_to have_content file.filename
      expect(page).not_to have_link 'Delete file'
    end

    context "when user is not answer's author" do
      given!(:answer) { create(:answer, :with_file, question: question) }

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
