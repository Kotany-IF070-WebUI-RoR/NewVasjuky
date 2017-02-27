require 'rails_helper'

describe IssuesController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:author) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :moderator) }

  describe 'Get event details when' do
    describe 'event is public' do
      let(:event) { create(:event, :approve, author_id: author.id) }
      let(:action) { get :show, params: { id: event.id } }

      it 'and user is not logged in' do
        expect(action).to have_http_status(:ok)
      end

      it 'and user is author of it' do
        sign_in author
        expect(action).to have_http_status(:ok)
      end

      it 'and user is not author of it' do
        sign_in reporter
        expect(action).to have_http_status(:ok)
      end

      it 'and user admin' do
        sign_in admin
        expect(action).to have_http_status(:ok)
      end

      it 'and user moderator' do
        sign_in moderator
        expect(action).to have_http_status(:ok)
      end
    end

    describe 'event is not public' do
      let(:event) { create(:event, :decline) }
      let(:action) { get :show, params: { id: event.id } }

      it 'and user is not logged in' do
        expect(action).to have_http_status(302)
      end

      it 'and user is author of it' do
        sign_in author
        expect(action).to have_http_status(302)
      end

      it 'and user is not author of it' do
        sign_in reporter
        expect(action).to have_http_status(302)
      end

      it 'and user admin' do
        sign_in admin
        expect(action).to have_http_status(302)
      end

      it 'and user moderator' do
        sign_in moderator
        expect(action).to have_http_status(302)
      end
    end
  end
end
