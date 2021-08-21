require 'rails_helper'

feature 'User can delete links from answer', %(
  In order to remove unnecessary links from my answer
  As an answer's author
  I'd like to be able to delete links
) do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer) { create(:answer, question: question, user: user) }
  given(:other_answer) { create(:answer, question: question) }
  given!(:link) { create(:link, linkable: answer) }
  given!(:other_link) { create(:link, linkable: other_answer) }

  scenario "Unauthenticated user can't delete links" do
    visit question_path(question)
    expect(page).to_not have_link 'Delete link'
  end

  describe 'Authenticated user' do
    background do
      login(user)
      visit question_path(question)
    end

    scenario "as answer's author can delete links", js: true do
      within "#answer-id-#{answer.id}" do
        expect(page).to have_link 'Test link', href: 'http://foo.bar.com'
        click_on 'Delete link'

        expect(page).to_not have_link 'Test link', href: 'http://foo.bar.com'
      end
    end

    scenario "and not author can't delete links" do
      within "#answer-id-#{other_answer.id}" do
        expect(page).to_not have_link 'Delete link'
      end
    end
  end
end