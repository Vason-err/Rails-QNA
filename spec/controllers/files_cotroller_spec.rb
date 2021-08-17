require 'rails_helper'

RSpec.describe FilesController, type: :controller do
  let!(:question) { create(:question, :with_file, user: user) }
  let(:user) { create(:user) }

  before { login(user) }

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: question.files.first.id }, format: :js }

    it 'should delete file' do
      expect { delete_destroy }.to change(ActiveStorage::Attachment, :count).by(-1)
    end

    context 'when the user is not the author' do
      let!(:question) { create(:question, :with_file) }

      it 'should not delete file' do
        expect { delete_destroy }.not_to change(ActiveStorage::Attachment, :count)
      end

      it 'returns forbidden' do
        delete_destroy
        expect(response).to be_forbidden
      end
    end
  end
end