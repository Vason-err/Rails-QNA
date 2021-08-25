# frozen_string_literal: true

require 'rails_helper'

feature 'User can view their rewards' do
  given(:user) { create(:user) }
  given!(:reward) { create(:reward, user: user) }
  given!(:other_reward) { create(:reward, user: user) }

  background { login(user) }

  scenario 'User sees rewards' do
    visit rewards_path

    expect(page).to have_content 'Rewards list'
    expect(page).to have_content reward.question.title
    expect(page).to have_content reward.title
    expect(page).to have_content other_reward.question.title
    expect(page).to have_content other_reward.title
  end
end
