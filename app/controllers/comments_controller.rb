# frozen_string_literal: true
class CommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    respond_to do |format|
      if @comment.save
        format.html { comments_list(1) }
      else
        format.json { comment_error }
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    @commentable = @comment.commentable
    if @comment.can_delete?(current_user)
      @comment.destroy
      respond_to do |format|
        format.html { comments_list(params[:page]) }
      end
    else
      redirect_to @commentable
    end
  end

  private

  def comments_list(page = 1)
    render partial: 'comments/comments_list',
           locals: { commentable: @commentable, page: page }
  end

  def comment_error
    render json: @comment.errors.messages, status: :unprocessable_entity
  end

  def comment_params
    params.require(:comment).permit(:title, :content)
  end
end
