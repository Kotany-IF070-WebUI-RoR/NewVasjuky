require 'rails_helper'

describe CommentsController, type: :controller do
  let(:reporter_1) { create(:user, :reporter) }
  let(:reporter_2) { create(:user, :reporter) }
  let(:banned_reporter) { create(:user, :reporter, banned: true) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :admin) }
  let(:commentable) { create(:issue, user: reporter_1) }
  let!(:comment) do
    create(:comment, user: reporter_1, commentable: commentable)
  end

  describe 'Remove comment with AJAX' do
    let(:action) { delete :destroy, xhr: true, params: { id: comment } }

    it 'when user is not logged in' do
      expect(action).to have_http_status(401)
      expect { action }.to change(Comment, :count).by(0)
    end

    it 'when user is reporter and author of it' do
      sign_in reporter_1
      expect { action }.to change(Comment, :count).from(1).to(0)
    end

    it 'when user is reporter but no author of it' do
      sign_in reporter_2
      expect { action }.to change(Comment, :count).by(0)
    end

    it 'when user is banned reporter' do
      sign_in banned_reporter
      expect { action }.to change(Comment, :count).by(0)
    end

    it 'when user moderator' do
      sign_in moderator
      expect { action }.to change(Comment, :count).from(1).to(0)
    end

    it 'when user admin' do
      sign_in admin
      expect { action }.to change(Comment, :count).from(1).to(0)
    end
  end

  describe 'Remove comment without AJAX' do
    let(:action) { delete :destroy, params: { id: comment } }

    it 'when user is not logged in' do
      expect(action).to have_http_status(302)
      expect { action }.to change(Comment, :count).by(0)
    end

    it 'when user is reporter and author of it' do
      sign_in reporter_1
      expect { action }.to change(Comment, :count).from(1).to(0)
    end

    it 'when user is reporter but no author of it' do
      sign_in reporter_2
      expect { action }.to change(Comment, :count).by(0)
    end

    it 'when user is banned reporter' do
      sign_in banned_reporter
      expect { action }.to change(Comment, :count).by(0)
    end

    it 'when user moderator' do
      sign_in moderator
      expect { action }.to change(Comment, :count).from(1).to(0)
    end

    it 'when user admin' do
      sign_in admin
      expect { action }.to change(Comment, :count).from(1).to(0)
    end
  end
end
