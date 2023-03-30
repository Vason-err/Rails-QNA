# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:rewards).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }

  describe '#author_of?' do
    let(:user) { create(:user) }
    let(:resource) { double user_id: user_id }
    let(:user_id) { user.id }

    it { expect(user).to be_author_of(resource) }

    context 'when the user is not the author' do
      let(:second_user) { create(:user) }
      let(:user_id) { second_user.id }

      it { expect(user).not_to be_author_of(resource) }
    end
  end

  describe '#vote_by' do
    let!(:user) { create(:user) }
    let!(:answer) { create(:answer) }
    let!(:vote) { create(:vote, user: user, voteable: answer) }

    it { expect(user.vote_by(answer)).to eq(vote) }

    context 'when user has not votes' do
      let!(:vote) { create(:vote, voteable: answer) }

      it { expect(user.vote_by(answer)).to be_nil }
    end
  end

  describe '#subscribed?' do
    let(:user) { create :user }

    let(:question) { create :question }

    it 'true if user is subscribed to question' do
      question.subscriptions.create!(user: user)
      expect(user).to be_subscribed(question)
    end

    it 'false if user is not subscribed to question' do
      expect(user).not_to be_subscribed(question)
    end
  end
end
