# Encoding: utf-8
class IssuesController < ApplicationController
  helper IssuesHelper
  before_action :status_inspector, only: [:index]
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:index, :show, :followees, :map, :popup]
  respond_to :html, :json

  def index
    issues_scope = Issue.where(status: params[:status])
    issues_scope = issues_scope.like(params[:filter]) if params[:filter]
    @status = params[:status]
    smart_listing_create :issues,
                         issues_scope,
                         partial: 'issues/issue'
    @categories = Category.ordered_by_name
  end

  def new
    @issue = current_user.issues.new
  end

  def show
    @issue = Issue.find(params[:id])
    @voted = @issue.votes.where(user_id: current_user.id)
    @relevant_issues = @issue.category.issues.where.not(id: @issue.id)
                             .order('random()').limit(4)
    redirect_back(fallback_location: root_path) unless \
                                                @issue.can_read?(current_user)
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
      redirect_to @issue, notice: 'Звернення створене успішно!'
    else
      render 'new'
    end
  end

  def upvote
    @issue = Issue.find(params[:id])
    @vote = @issue.votes.new
    @vote.user = current_user
    @vote.save
    redirect_to @issue, notice: "Ви проголосували за дану проблему."
  end

  def downvote
    @issue = Issue.find(params[:id])
    @vote = @issue.votes.where(user_id: current_user.id)
    @issue.votes.destroy(@vote)
    redirect_to @issue, notice: "Ви зняли голос з даної проблеми."
  end

  private

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

  def status_inspector
    redirect_back(fallback_location: root_path) unless
      %w(opened closed).include?(params[:status])
  end
end
