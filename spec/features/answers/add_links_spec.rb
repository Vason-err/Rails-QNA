require 'rails_helper'

feature 'user can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given(:gist_url) { 'https://gist.github.com/Vason-err/ebf797de8d60c832da5a00023a9ea20f' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links when asks answer', js: true do
    login(user)
    visit question_path(question)

    fill_in "Body", with: "Test answer"

    click_on 'add link'
    within '.nested-fields:last-of-type' do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url
    end
    click_on 'add link'
    within '.nested-fields:last-of-type' do
      fill_in 'Link name', with: 'Google'
      fill_in 'Url', with: google_url
    end

    click_on "Answer"

    within '.answers' do
      expect(page).to have_content 'gist for qna'
      expect(page).to have_link 'Google', href: google_url
    end
  end
end