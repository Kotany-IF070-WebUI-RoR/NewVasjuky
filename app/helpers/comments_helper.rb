# frozen_string_literal: true
module CommentsHelper
  def paginate_comments_of(commentable)
    commentable.comments.ordered.page(params[:page]).per(15)
  end
end
