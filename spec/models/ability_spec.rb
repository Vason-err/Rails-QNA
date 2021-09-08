require 'rails_helper'

describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create :user, admin: true }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let(:user) { create :user }
    let(:other) { create :user }

    let(:question1) { create(:question, :with_files, user: user) }
    let(:question2) { create(:question, :with_files, user: other) }
    let(:answer1) { create(:answer, :with_files, user: user) }
    let(:answer2) { create(:answer, :with_files, user: other) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :create, Comment }

    it { should be_able_to :update, create(:question, user: user) }
    it { should_not be_able_to :update, create(:question, user: other) }

    it { should be_able_to :update, create(:answer, user: user) }
    it { should_not be_able_to :update, create(:answer, user: other) }


    it { should be_able_to :destroy, create(:question, user: user) }
    it { should_not be_able_to :destroy, create(:question, user: other) }

    it { should be_able_to :destroy, create(:answer, user: user) }
    it { should_not be_able_to :destroy, create(:answer, user: other) }


    it { should be_able_to :destroy, question1.files.first }
    it { should_not be_able_to :destroy, question2.files.first }
    it { should be_able_to :destroy, answer1.files.first }
    it { should_not be_able_to :destroy, answer2.files.first }

    it { should be_able_to :destroy, create(:link, linkable: create(:question, user: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:question, user: other)) }
    it { should be_able_to :destroy, create(:link, linkable: create(:answer, user: user)) }
    it { should_not be_able_to :destroy, create(:link, linkable: create(:answer, user: other)) }

    it { should be_able_to :mark_as_best, create(:answer, user: user) }
    it { should_not be_able_to :mark_as_best, create(:answer, user: other) }

    it { should_not be_able_to :plus, create(:question, user: user) }
    it { should be_able_to :plus, create(:question, user: other) }

    it { should_not be_able_to :plus, create(:answer, user: user) }
    it { should be_able_to :plus, create(:answer, user: other) }

    it { should_not be_able_to :minus, create(:question, user: user) }
    it { should be_able_to :minus, create(:question, user: other) }

    it { should_not be_able_to :minus, create(:answer, user: user) }
    it { should be_able_to :minus, create(:answer, user: other) }
  end
end