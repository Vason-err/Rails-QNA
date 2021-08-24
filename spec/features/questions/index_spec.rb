# frozen_string_literal: true

require 'rails_helper'

feature 'user can show questions', "
  In order to find the answer to the question
  As an user
  I'd like to be able to show questions
" do
  shared_examples 'questions list' do
    scenario 'tries to show questions' do
      visit questions_path

      expect(page).to have_content('Questions')
      questions.each do |question|
        expect(page).to have_content(question.title)
      end
    end
  end

  given(:user) { create(:user) }
  given!(:questions) { create_list(:question, 3) }

  describe 'authenticated user' do
    background { login(user) }

    it_behaves_like 'questions list'
  end

  describe 'unauthenticated user' do
    it_behaves_like 'questions list'
  end
end
