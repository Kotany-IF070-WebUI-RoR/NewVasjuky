# frozen_string_literal: true
class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      render_comments_list
      start_following
    else
      respond_to { |format| format.json { comment_error } }
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    if @comment.can_delete?(current_user)
      @comment.destroy
      render_comments_list
    else
      redirect_to @commentable
    end
  end

  private

  def render_comments_list
    render partial: 'comments/comments_list',
           locals: { commentable: @commentable }
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
