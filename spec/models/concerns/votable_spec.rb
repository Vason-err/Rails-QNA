require 'rails_helper'

RSpec.describe Voteable, type: :concern do
  with_model :WithVoteable do
    model do
      include Voteable
    end
  end

  let!(:with_voteable) { WithVoteable.create }
  let!(:votes) { create_list(:positive_vote, 3, voteable: with_voteable) }

  describe '#vote_rating' do
    subject { with_voteable.vote_rating }

    it do
      is_expected.to eq(3)
    end

    context 'when negative' do
      let!(:votes) { create_list(:negative_vote, 3, voteable: with_voteable) }

      it do
        is_expected.to eq(-3)
      end
    end

    context 'when composite' do
      let!(:votes) { create_list(:positive_vote, 3, voteable: with_voteable) }
      let!(:negative_votes) { create_list(:negative_vote, 2, voteable: with_voteable) }

      it do
        is_expected.to eq(1)
      end
    end
  end
end