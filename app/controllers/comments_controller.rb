# frozen_string_literal: true
class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user, only: [:show]
  before_action :authenticate_user!

  def index
    return redirect_back(fallback_location: root_path) unless request.xhr?

    @comments = @commentable.comments.ordered.page(params[:page]).per(5)
    if @comments.any?
      render partial: 'comments/comments_list', locals: { comments: @comments },
             status: :ok
    else
      render text: 'end_of_comments_list', status: 444
    end
  end

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      start_following
      render partial: 'comments/comment',
             locals: { comment: @comment }
    else
      respond_to { |format| format.json { comment_error } }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    if @comment.can_delete?(current_user)
      @comment.destroy
    else
      redirect_to @commentable
    end
  end

  private

  def comment_error
    render json: @comment.errors.messages, status: :unprocessable_entity
  end

  def comment_params
    params.require(:comment).permit(:title, :content)
  end

  def start_following
    @commentable.followable? && !current_user.follows?(@commentable) &&
      current_user.follow!(@commentable)
  end
end
