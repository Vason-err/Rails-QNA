require 'rails_helper'

feature 'user can mark answer as best', %q{
  In order to indicate best answer
  As an author of question
  I'd like ot be able to mark answer as best
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background { login(user) }

    background { visit question_path(question) }

    scenario 'marks answer as best' do
      within '.answers' do
        within first('.answer') do
          click_on 'Mark as best'

          expect(page).not_to have_content 'Mark as best'
        end

        expect(page).to have_css '.best'
      end
    end

    context "when user is not question's author" do
      given!(:question) { create(:question) }

      scenario "tries to mark answer as best" do
        within '.answers' do
          expect(page).to_not have_content 'Mark as best'
        end
      end
    end
  end

  describe 'unauthenticated user' do
    scenario 'can not mark as best answer' do
      visit question_path(question)

      within '.answers' do
        expect(page).to_not have_link 'Mark as best'
      end
    end
  end
end