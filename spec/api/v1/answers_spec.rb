require 'rails_helper'

describe 'Answers API', type: :request do
  let(:user) { create(:user) }
  let(:question) { create(:question) }
  let(:answer) { create(:answer) }
  let(:public_fields) { %w[id body created_at updated_at question_id] }

  describe 'GET /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'when authorized' do
      let!(:answers) { create_list(:answer, 3, question: question) }
      let(:answer) { answers.first }

      let(:answers_response) { json['answers'] }
      let(:answer_response) { answers_response.first }

      before { authorized_request(user, :get, "/api/v1/questions/#{question.id}/answers") }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Countable' do
        let(:items_response) { answers_response }
        let(:items) { answers }
      end

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { answer_response }
        let(:item) { answer }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { answer_response }
        let(:item) { answer }
      end
    end
  end

  describe 'GET /api/v1/answers/:id' do
    let(:answer) { create(:answer, :with_file, question: question) }

    it_behaves_like 'API Unauthorizable' do
      let(:method) { :get }
      let(:api_path) { "/api/v1/answers/#{answer.id}/" }
    end

    context 'when authorized' do
      let!(:link) { create(:link, linkable: answer) }
      let!(:comment) { create(:comment, commentable: answer) }

      let(:answer_response) { json['answer'] }

      before { authorized_request(user, :get,  "/api/v1/answers/#{answer.id}") }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { answer_response }
        let(:item) { answer }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { answer_response }
        let(:item) { answer }
      end

      context 'with links' do
        it_behaves_like 'API Countable' do
          let(:items_response) { answer_response['links'] }
          let(:items) { answer.links }
        end

        it_behaves_like 'API Publicable' do
          let(:fields) { %w[id name url created_at updated_at] }
          let(:item_response) { answer_response['links'].first }
          let(:item) { link }
        end
      end

      context 'with comments' do
        it_behaves_like 'API Countable' do
          let(:items_response) { answer_response['comments'] }
          let(:items) { answer.comments }
        end

        it_behaves_like 'API Publicable' do
          let(:fields) { %w[id text created_at updated_at] }
          let(:item_response) { answer_response['comments'].first }
          let(:item) { comment }
        end
      end

      context 'with files' do
        it_behaves_like 'API Countable' do
          let(:items_response) { answer_response['files'] }
          let(:items) { answer.files }
        end
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :post }
      let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    end

    context 'when authorized' do
      let(:answer) { question.answers.first }
      let(:answer_response) { json['answer'] }

      let(:answer_params) do
        {
          body: 'Body'
        }
      end

      before { authorized_request(user, :post, "/api/v1/questions/#{question.id}/answers", params: { answer: answer_params }) }

      it_behaves_like 'API Successable'

      it 'create answer' do
        expect(answer).to have_attributes(body: 'Body', user_id: user.id)
      end

      it_behaves_like 'API Publicable' do
        let(:fields) {public_fields }
        let(:item_response) { answer_response }
        let(:item) { answer }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { answer_response }
        let(:item) { answer }
      end

      shared_examples_for 'API Errorable' do
        let(:answer_params) do
          {
            body: nil
          }
        end

        let(:errors) { ["Body can't be blank"] }
      end
    end
  end

  describe 'PATCH /api/v1/answers/:answer_id' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :patch }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'when authorized' do
      let(:answer) { create(:answer, user: user) }
      let(:answer_response) { json['answer'] }

      let(:answer_params) do
        {
          body: 'New Body'
        }
      end

      before { authorized_request(user, :patch, "/api/v1/answers/#{answer.id}", params: { answer: answer_params }) }

      it_behaves_like 'API Successable'

      it 'update answer' do
        expect(answer.reload).to have_attributes(body: 'New Body')
      end

      it_behaves_like 'API Publicable' do
        let(:fields) { public_fields }
        let(:item_response) { answer_response }
        let(:item) { answer.reload }
      end

      it_behaves_like 'API User Containable' do
        let(:item_response) { answer_response }
        let(:item) { answer.reload }
      end

      shared_examples_for 'API Errorable' do
        let(:answer_params) do
          {
            body: nil
          }
        end

        let(:errors) { ["Body can't be blank"] }
      end

      it_behaves_like 'API Authorize Errorable' do
        let(:answer) { create(:answer) }
      end
    end
  end

  describe 'DELETE /api/v1/answer/:answer_id' do
    it_behaves_like 'API Unauthorizable' do
      let(:method) { :delete }
      let(:api_path) { "/api/v1/answers/#{answer.id}" }
    end

    context 'when authorized' do
      let(:answer) { create(:answer, user: user) }

      before { authorized_request(user, :delete, "/api/v1/answers/#{answer.id}") }

      it_behaves_like 'API Successable'

      it_behaves_like 'API Authorize Errorable' do
        let(:answer) { create(:answer) }
      end
    end
  end
end
