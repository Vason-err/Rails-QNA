# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Link, type: :model do
  it { should belong_to :linkable }

  it { should validate_presence_of :name }
  it { should validate_presence_of :url }
  it { should allow_values('http://foo.bar', 'https://foo.bar.com').for(:url) }

  describe '#gist?' do
    let(:link_to_gist) { create(:link, url: 'https://gist.github.com/Vason-err/ebf797de8d60c832da5a00023a9ea20f') }
    let(:link) { create(:link) }

    describe 'gist instead link' do
      it { expect(link_to_gist).to be_gist }
    end

    describe 'really link' do
      it { expect(link).to_not be_gist }
    end
  end
end
