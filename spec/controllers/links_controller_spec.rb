# frozen_string_literal: true

require 'rails_helper'

RSpec.describe LinksController, type: :controller do
  let(:user) { create(:user) }
  let(:question) { create(:question, user: user) }
  let!(:link) { create(:link, linkable: question) }
  let!(:other_link) { create(:link) }

  describe 'DELETE #destroy' do
    let(:delete_destroy) { delete :destroy, params: { id: link_id, format: :js } }
    before { login(user) }

    context 'author of record' do
      let(:link_id) { link }
      it 'delete the link' do
        expect { delete_destroy }.to change(Link, :count).by(-1)
      end

      it 'render destroy view' do
        delete_destroy
        expect(response).to render_template :destroy
      end
    end

    context 'not author of record' do
      let(:link_id) { other_link }
      it 'no delete the link' do
        expect { delete_destroy }.to_not change(Link, :count)
      end

      it 'render forbidden' do
        delete_destroy
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
