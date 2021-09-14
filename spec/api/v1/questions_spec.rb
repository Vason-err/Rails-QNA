require 'rails_helper'

describe 'Questions API', type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:public_fields) { %w[id title body created_at updated_at] }

  describe 'GET /api/v1/questions' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { '/api/v1/questions' }
    end

    context 'when authorized' do
      let!(:questions) { create_list(:question, 3) }
      let(:question) { questions.first }

      let(:questions_response) { json['questions'] }
      let(:question_response) { questions_response.first }

      before { authorized_request(user, :get, '/api/v1/questions') }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Countable' do
        let(:items_response) { questions_response }
        let(:items) { questions }
      end

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { question_response }
        let(:item) { question }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { question_response }
        let(:item) { question }
      end
    end
  end

  describe 'GET /api/v1/questions/:id' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'when authorized' do
      let(:question) { create(:question, :with_file) }
      let!(:link) { create(:link, linkable: question) }
      let!(:comment) { create(:comment, commentable: question) }

      let(:question_response) { json['question'] }

      before { authorized_request(user, :get, "/api/v1/questions/#{question.id}") }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { question_response }
        let(:item) { question }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { question_response }
        let(:item) { question }
      end

      context 'with links' do
        it_behaves_like 'API Countable' do
          let(:items_response) { question_response['links'] }
          let(:items) { question.links }
        end

        it_behaves_like 'API Publicable' do
          let(:fields) { %w[id name url created_at updated_at] }
          let(:item_response) { question_response['links'].first }
          let(:item) { link }
        end
      end

      context 'with comments' do
        it_behaves_like 'API Countable' do
          let(:items_response) { question_response['comments'] }
          let(:items) { question.comments }
        end

        it_behaves_like 'API Publicable' do
          let(:fields) { %w[id text created_at updated_at] }
          let(:item_response) { question_response['comments'].first }
          let(:item) { comment }
        end
      end

      context 'with files' do
        it_behaves_like 'API Countable' do
          let(:items_response) { question_response['files'] }
          let(:items) { question.files }
        end
      end
    end
  end

  describe 'POST /api/v1/questions' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions" }
    end

    context 'when authorized' do
      let(:question) { Question.last }
      let(:question_response) { json['question'] }

      let(:question_params) do
        {
          title: 'Title',
          body: 'Body'
        }
      end

      before { authorized_request(user, :post, '/api/v1/questions', params: { question: question_params }) }

      it_behaves_like 'API Successable'

      it 'create question' do
        expect(question).to have_attributes(title: 'Title', body: 'Body', user_id: user.id)
      end

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { question_response }
        let(:item) { question }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { question_response }
        let(:item) { question }
      end

      shared_examples_for 'API Errorable' do
        let(:question_params) do
          {
            title: 'Title'
          }
        end

        let(:errors) { ["Body can't be blank"] }
      end
    end
  end

  describe 'PATCH /api/v1/questions/:question_id' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'when authorized' do
      let(:question) { create(:question, user: user) }
      let(:question_response) { json['question'] }

      let(:question_params) do
        {
          title: 'New Title',
          body: 'New Body'
        }
      end

      before { authorized_request(user, :patch, "/api/v1/questions/#{question.id}", params: { question: question_params }) }

      it_behaves_like 'API Successable'

      it 'update question' do
        expect(question.reload).to have_attributes(title: 'New Title', body: 'New Body', user_id: user.id)
      end

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { question_response }
        let(:item) { question.reload }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { question_response }
        let(:item) { question.reload }
      end

      shared_examples_for 'API Errorable' do
        let(:question_params) do
          {
            title: 'New Title',
            body: nil
          }
        end

        let(:errors) { ["Body can't be blank"] }
      end

      it_behaves_like 'API Authorize Errorable' do
        let(:question) { create(:question) }
      end
    end
  end

  describe 'DELETE /api/v1/questions/:question_id' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/questions/#{question.id}" }
    end

    context 'when authorized' do
      let(:question) { create(:question, user: user) }

      before { authorized_request(user, :delete, "/api/v1/questions/#{question.id}") }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Authorize Errorable' do
        let(:question) { create(:question) }
      end
    end
  end
end
