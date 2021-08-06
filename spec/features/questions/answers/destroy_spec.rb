require 'rails_helper'

feature 'user can delete answer' do
  shared_examples 'no link to delete' do
    scenario 'tries to delete answer' do
      visit question_path(question)

      expect(page).not_to have_content('Delete answer')
    end
  end

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'authenticated user' do
    background { login(user) }

    scenario 'tries to delete answer', js: true do
      visit question_path(question)

      expect(page).to have_content answer.body

      click_on 'Delete answer'

      expect(page).not_to have_content answer.body
    end

    context 'when the user is not the author of the answer' do
      given!(:answer) { create(:answer, question: question) }

      it_behaves_like 'no link to delete'
    end
  end

  describe 'unauthenticated user' do
    it_behaves_like 'no link to delete'

    context 'when the user is not the author of the answer' do
      given!(:answer) { create(:answer, question: question) }

      it_behaves_like 'no link to delete'
    end
  end
end