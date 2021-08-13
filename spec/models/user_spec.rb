require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:questions).dependent(:destroy) }
  it { should have_many(:answers).dependent(:destroy) }

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
end

