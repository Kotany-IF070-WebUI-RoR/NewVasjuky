# Encoding: utf-8
class IssuesController < ApplicationController
  helper IssuesHelper
  before_action :status_inspector, only: [:index]
  before_action :init_issue, only: [:show, :upvote, :downvote]
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:index, :show, :followees, :map, :popup]
  respond_to :html, :json

  def index
    @status = params[:status] || 'opened'
    issues_scope = Issue.ordered
                        .where(status: @status)
    issues_scope = issues_scope.like(params[:filter]) if params[:filter]
    smart_listing_create :issues,
                         issues_scope,
                         partial: 'issues/issue'
    @categories = Category.ordered_by_name
  end

  def new
    @issue = current_user.issues.new
  end

  def show
    @attachments = @issue.issue_attachments
    @voted = @issue.votes.where(user_id: current_user.id)
    @event = @issue.events.new
    load_relevant_issues
  end

  def map
    @issues = Issue.select('id,latitude, longitude').approved
    respond_with(@issues)
  end

  def popup
    @issue = Issue.find(params[:id])
    respond_with(id: @issue.id,
                 title: @issue.title,
                 description: @issue.description,
                 created_at: l(@issue.created_at, format: :short),
                 img: @issue.first_attached_image)
  end

  def followees
    @issues = current_user.followees(Issue)
  end

  def create
    @issue = current_user.issues.new(issues_params)
    if @issue.save
      current_user.follow!(@issue)
      redirect_to @issue, notice: 'Звернення створене успішно!'
    else
      render 'new'
    end
  end

  def upvote
    @vote = @issue.votes.build user: current_user
    if @vote.save
      redirect_to @issue
    else
      redirect_to @issue, notice: 'Ви не змогли проголосувати'
    end
  end

  def downvote
    @vote = @issue.votes.find_by(user_id: current_user.id)
    if @vote.present?
      @issue.votes.destroy(@vote)
      redirect_to @issue
    else
      redirect_to @issue, notice: 'Ви уже забрали свій голос.'
    end
  end

  private

  def load_relevant_issues
    @relevant_issues = @issue.category.issues.where.not(id: @issue.id)
                             .order('random()').limit(4)
    redirect_back(fallback_location: root_path) unless \
                      @issue.can_read?(current_user)
  end

  def issues_params
    params.require(:issue).permit(:name, :address, :phone,
                                  :email,
                                  :category_id,
                                  :description,
                                  :location,
                                  :title,
                                  issue_attachments_attributes: [
                                    :attachment,
                                    :_destroy
                                  ])
  end

  def init_issue
    @issue = Issue.find(params[:id])
  end

  def status_inspector
    redirect_back(fallback_location: root_path) unless
      %w(opened closed).include?(params[:status]) || params[:status].blank?
  end
end
