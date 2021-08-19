require 'rails_helper'

feature 'user can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://github.com/Vason-err/Rails-QNA/' }

  scenario 'User adds links when asks answer', js: true do
    login(user)
    visit question_path(question)

    fill_in "Body", with: "Test answer"
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_url

    click_on "Answer"

    within '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end