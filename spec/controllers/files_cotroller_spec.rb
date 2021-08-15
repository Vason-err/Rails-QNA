require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:question) { create(:question, :with_file, user: user) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'DELETE #destroy' do
    subject { delete :destroy, params: { id: question.files.first }, format: :js }

    it 'should delete file' do
      expect { subject }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    context 'when the user is not the author' do
      let!(:question) { create(:question, :with_file) }

      it 'should not delete file' do
        expect { subject }.not_to change(ActiveStorage::Attachment, :count)
      end
    end
  end
end