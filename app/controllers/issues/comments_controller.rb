module Issues
  class CommentsController < ::CommentsController
    before_action :set_commentable

    private

    def set_commentable
      @commentable = Issue.find(params[:issue_id])
    end
  end
end
