require 'rails_helper'

describe Issues::CommentsController, type: :controller do
  let(:reporter) { create(:user, :reporter) }
  let(:banned_reporter) { create(:user, :reporter, active: false) }
  let(:admin) { create(:user, :admin) }
  let(:moderator) { create(:user, :admin) }
  let(:commentable) { create(:issue, user: reporter, status: 'opened') }
  let(:valid_comment) { build(:comment, commentable: commentable) }

  describe 'Get comments when' do
    let!(:create_comment) { create(:comment, commentable: commentable) }
    let(:xhr) { get :index, xhr: true, params: { issue_id: commentable } }
    let(:no_xhr) { get :index, xhr: false, params: { issue_id: commentable } }

    it 'XHR' do
      expect(xhr).to have_http_status(200)
      expect(xhr).to render_template(partial: 'comments/_comments_list')
    end

    it 'not XHR' do
      expect(no_xhr).to have_http_status(302)
    end
  end

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

    it 'user is banned' do
      sign_in banned_reporter
      expect { action }.to change(Comment, :count).by(0)
      expect(action).to have_http_status(302)
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

    it 'user is banned' do
      sign_in banned_reporter
      expect { action }.to change(Comment, :count).by(0)
      expect(action).to have_http_status(302)
    end
  end

  describe 'Follow issue when comment it and' do
    let(:action) do
      post :create, params: { issue_id: commentable,
                              comment: valid_comment.attributes }
    end

    it 'user is reporter' do
      sign_in reporter
      action
      expect(reporter.follows?(commentable)).to be_truthy
    end

    it 'user is admin' do
      sign_in admin
      action
      expect(admin.follows?(commentable)).to be_truthy
    end

    it 'user is moderator' do
      sign_in moderator
      action
      expect(moderator.follows?(commentable)).to be_truthy
    end
  end

  describe 'Follow issue when comment it and' do
    let(:action) do
      post :create, params: { issue_id: commentable,
                              comment: valid_comment.attributes }
    end

    it 'user is reporter' do
      sign_in reporter
      action
      expect(reporter.follows?(commentable)).to be_truthy
    end

    it 'user is admin' do
      sign_in admin
      action
      expect(admin.follows?(commentable)).to be_truthy
    end

    it 'user is moderator' do
      sign_in moderator
      action
      expect(moderator.follows?(commentable)).to be_truthy
    end
  end
end
