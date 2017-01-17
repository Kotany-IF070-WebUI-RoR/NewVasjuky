require 'rails_helper'

describe Issues::CommentsController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :admin) }
  let(:commentable) { create(:issue, user: reporter) }
  let(:valid_comment) { build(:comment, commentable: commentable) }
  describe 'Create comment with AJAX when it is valid and ' do
    let(:action) do
      post :create, xhr: true, params: { issue_id: commentable,
                                         comment: valid_comment.attributes }
    end

    it 'user is not logged in' do
      expect { action }.to change(Comment, :count).by(0)
      expect(action).to have_http_status(401)
    end

    it 'user is logged in' do
      sign_in reporter
      expect { action }.to change(Comment, :count).by(1)
    end
  end

  describe 'Create comment without AJAX when' do
    let(:action) do
      post :create, params: { issue_id: commentable,
                              comment: valid_comment.attributes }
    end

    it 'user is not logged in' do
      expect { action }.to change(Comment, :count).by(0)
      expect(action).to have_http_status(302)
    end

    it 'user is logged in' do
      sign_in reporter
      expect { action }.to change(Comment, :count).by(1)
    end
  end
end
