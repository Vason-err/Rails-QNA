require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should belong_to(:user) }

  it { should have_many(:answers).order('best DESC, created_at').dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
end
