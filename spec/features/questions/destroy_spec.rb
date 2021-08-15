require 'rails_helper'

feature 'user can delete question' do
  shared_examples 'no link to delete' do
    scenario 'tries to delete question' do
      visit question_path(question)

      expect(page).not_to have_content('Delete question')
    end
  end

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }

  describe 'authenticated user' do
    background { login(user) }

    scenario 'tries to delete question' do
      visit question_path(question)

      expect(page).to have_content question.title

      click_on 'Delete question'

      expect(page).not_to have_content question.title
    end

    context 'when the user is not the author of the question' do
      given(:question) { create(:question) }

      it_behaves_like 'no link to delete'
    end
  end

  describe 'unauthenticated user' do
    it_behaves_like 'no link to delete'

    context 'when the user is not the author of the question' do
      given(:question) { create(:question) }

      it_behaves_like 'no link to delete'
    end
  end
end