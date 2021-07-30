require 'rails_helper'

RSpec.describe QuestionsController, type: :controller do
  describe 'GET #show' do
    let(:question) { create(:question) }

    before { get :show, params: { id: question } }

    it 'assigns the requested question to @question' do
      expect(assigns(:question)).to eq question
    end

    it 'renders show view' do
      expect(response).to render_template :show
    end
  end

  describe 'authenticated user' do
    let(:user) { create(:user) }

    before { login(user) }

    describe 'GET #new' do
      before { get :new }

      it 'assigns a new Question to @quetstion' do
        expect(assigns(:question)).to be_a_new(Question)
      end

      it 'renders new view' do
        expect(response).to render_template :new
      end
    end

    describe 'POST #create' do
      let(:post_create) { post :create, params: { question: question_params } }
      context 'with valid attributes' do
        let(:question_params) { attributes_for(:question) }
        it 'saves a new question in the database' do
          expect { post_create }.to change(Question, :count).by(1)
        end

        it 'redirects to show view' do
          post_create

          expect(response).to redirect_to assigns(:question)
        end
      end

      context 'with invalid attributes' do
        let(:question_params) { attributes_for(:question, :invalid) }
        it 'does not save the question' do
          expect { post_create }.to_not change(Question, :count)
        end

        it 're-renders new view' do
          post_create

          expect(response).to render_template :new
        end
      end
    end

    describe 'DELETE #destroy' do

      let(:delete_destroy) { delete :destroy, params: { id: question.id } }

      let!(:question) { create(:question, user: user) }

      it 'should delete question' do
        expect { delete_destroy }.to change(Question, :count).by(-1)
      end

      it 'redirects to questions' do
        is_expected.to redirect_to questions_path
      end

      context 'when the user is not the author' do
        let!(:question) { create(:question) }

        it 'should not delete question' do
          expect { delete_destroy }.to change(Question, :count).by(0)
        end

        it 'redirects to question' do
          is_expected.to redirect_to question_path(question)
        end
      end
    end

  end
end
