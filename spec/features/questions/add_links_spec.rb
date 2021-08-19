require 'rails_helper'

feature 'user can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:gist_url) { 'https://gist.github.com/Vason-err/075a589d86e2090c4e96396c54df65ac' }
  given(:google_url) { 'https://www.google.com/' }

  scenario 'User adds links when asks question', js: true do
    login(user)
    visit new_question_path

    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'

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

    click_on 'Ask'

    expect(page).to have_link 'My gist', href: gist_url
    expect(page).to have_link 'Google', href: google_url
  end
end
