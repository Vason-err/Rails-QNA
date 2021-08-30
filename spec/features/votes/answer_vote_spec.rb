require 'rails_helper'

feature 'user can vote on answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  shared_examples 'show vote rating' do
    scenario do
      within '.answers' do
        expect(page).to have_content 'Vote'
        expect(page).to have_content 'Rating:0'
      end
    end
  end

  shared_examples 'without vote links' do
    scenario do
      within '.answers' do
        expect(page).not_to have_link 'Plus'
        expect(page).not_to have_link 'Minus'
      end
    end
  end

  describe 'authenticated user', js: true do
    background { login(user) }
    background { visit question_path(question) }

    it_behaves_like 'show vote rating'

    scenario 'show vote links' do
      within '.answers' do
        expect(page).to have_link 'Plus'
        expect(page).to have_link 'Minus'
      end
    end

    scenario 'positive vote' do
      within '.answers' do
        click_on 'Plus'

        within '.vote-block' do
          expect(page).to have_content 'Rating:1'
          expect(page).to have_link 'Delete'

          click_on 'Delete'

          expect(page).to have_content 'Rating:0'
          expect(page).not_to have_link 'Delete'
          expect(page).to have_link 'Plus'
          expect(page).to have_link 'Minus'
        end
      end
    end

    scenario 'negative vote' do
      within '.answers' do
        click_on 'Minus'

        within '.vote-block' do
          expect(page).to have_content 'Rating:-1'
          expect(page).to have_link 'Delete'

          click_on 'Delete'

          expect(page).to have_content 'Rating:0'
          expect(page).not_to have_link 'Delete'
          expect(page).to have_link 'Plus'
          expect(page).to have_link 'Minus'
        end
      end
    end

    context 'user is question author' do
      given(:answer) { create(:answer, user: user, question: question) }

      it_behaves_like 'show vote rating'
      it_behaves_like 'without vote links'
    end
  end

  describe 'unauthenticated user', js: true do
    background { visit question_path(question) }

    it_behaves_like 'show vote rating'
    it_behaves_like 'without vote links'
  end
end