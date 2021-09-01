require 'rails_helper'

feature 'user can add comment to answer' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'authenticated user', js: true do
    background { login(user) }
    background { visit question_path(question) }

    context 'try create comment' do
      scenario do
        within "#answer-id-#{answer.id}" do
          expect(page).to have_content 'New comment'

          within '.new-comment-form' do
            fill_in 'Text', with: 'Comment text'
            click_on 'Comment'
          end

          within '.answer-comments' do
            expect(page).to have_content 'Comment text'
          end
        end
      end

      context 'with invalid params' do
        scenario  do
          within "#answer-id-#{answer.id}" do
            expect(page).to have_content 'New comment'

            within '.new-comment-form' do
              click_on 'Comment'

              expect(page).to have_content "Text can't be blank"
            end
          end
        end
      end
    end
  end

  describe 'unauthenticated user', js: true do
    background { visit question_path(question) }

    scenario do
      within "#answer-id-#{answer.id}" do
        expect(page).not_to have_content 'New comment'
      end
    end
  end

  context 'multiple sessions', js: true do
    scenario "comment appears on another user's page" do
      Capybara.using_session('user') do
        login(user)
        visit question_path(question)
      end

      Capybara.using_session('guest') do
        visit question_path(question)
      end

      Capybara.using_session('user') do
        within "#answer-id-#{answer.id}" do
          within '.new-comment-form' do
            fill_in 'Text', with: 'Comment text'
            click_on 'Comment'
          end

          within '.answer-comments' do
            expect(page).to have_content 'Comment text'
          end
        end
      end

      Capybara.using_session('guest') do
        within "#answer-id-#{answer.id}" do
          within '.answer-comments' do
            expect(page).to have_content 'Comment text'
          end
        end
      end
    end
  end
end
