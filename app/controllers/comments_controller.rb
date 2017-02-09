# frozen_string_literal: true
class CommentsController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user, only: [:index]
  before_action :authenticate_user!

  def index
    return redirect_back(fallback_location: root_path) unless request.xhr?
    @comments = @commentable.comments.ordered.page(params[:page]).per(5)
    set_headers_for_index
    render partial: 'comments/comments_list', locals: { comments: @comments }
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
      render json: nil, status: :ok
      @comment.destroy
    else
      redirect_to @commentable
    end
  end

  private

  def set_headers_for_index
    response.headers['TotalPages'] = @comments.total_pages
  end

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
