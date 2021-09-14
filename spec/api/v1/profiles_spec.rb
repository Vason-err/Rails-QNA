require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:user) { create(:user) }
  let(:public_fields) { %w[id email admin created_at updated_at] }
  let(:private_fields) { %w[password encrypted_password] }

  describe 'GET /api/v1/profiles/me' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles/me' }
    end

    context 'when authorized' do
      before { authorized_request(user, :get, '/api/v1/profiles/me') }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { json['user'] }
        let(:item) { user }
      end

      it_behaves_like 'API Privatable' do
        let(:fields) { private_fields }
        let(:item_response) { json['user'] }
      end
    end
  end

  describe 'GET /api/v1/profiles' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/profiles' }
    end

    context 'when authorized' do
      let(:users_response) { json['users'] }

      let!(:users) { create_list(:user, 3) }

      before { authorized_request(user, :get, '/api/v1/profiles') }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Countable' do
        let(:items_response) { users_response }
        let(:items) { users }
      end

      it 'returns all users without authorized' do
        expect(users_response.pluck('id')).to eq(users.pluck(:id))
      end

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { users_response.first }
        let(:item) { users.first }
      end

      it_behaves_like 'API Privatable' do
        let(:fields) { private_fields }
        let(:item_response) { users_response.first }
      end
    end
  end
end