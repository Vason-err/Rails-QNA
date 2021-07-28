require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }

  describe 'GET #new' do
    before { get :new, params: { question_id: question } }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'answer belongs to question' do
      expect(assigns(:answer).question).to eq question
    end

    it 'renders new view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    let(:post_create) { post :create, params: { question_id: question, answer: answer_params } }
    context 'with valid attributes' do
      let(:answer_params) { attributes_for(:answer) }
      it 'saves a new answer in the database' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer) } }.to change(question.answers, :count).by(1)
      end

      it 'redirects to related question show view' do
        post_create

        expect(response).to redirect_to question
      end
    end

    context 'with invalid attributes' do
      let(:answer_params) { attributes_for(:answer, :invalid) }
      it 'does not save the question' do
        expect { post :create, params: { question_id: question, answer: attributes_for(:answer, :invalid) } }.to_not change(Answer, :count)
      end

      it 're-renders new view' do
        post_create

        expect(response).to render_template :new
      end
    end
  end
end
