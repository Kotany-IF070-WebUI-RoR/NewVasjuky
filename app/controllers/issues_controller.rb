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
    feed_metatags
    smart_listing_create :issues,
                         issues_scope,
                         partial: 'issues/issue'
    @categories = Category.ordered_by_name
  end

  def new
    set_meta_tags title: 'Створити нове звернення'
    @issue = current_user.issues.new
  end

  def show
    @issue = Issue.find(params[:id])
    issues_metatags
    relevant_issues
    redirect_back(fallback_location: root_path) unless \
                                                @issue.can_read?(current_user)
  end

  def map
    set_meta_tags title: 'Карта звернень'
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
    set_meta_tags title: 'Відслідковувані звернення'
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

  private

  def relevant_issues
    @relevant_issues = @issue.category.issues.where.not(id: @issue.id)
                             .order('random()').limit(4)
  end

  def issues_metatags
    set_meta_tags title: @issue.title,
                  description: @issue.description
  end

  def feed_metatags
    set_meta_tags description: 'На цій сторінці можна побачити список
                                звернень з обраним статусом'
    if @status == 'opened'
      set_meta_tags title: 'Відкриті звернення'
    elsif @status == 'closed'
      set_meta_tags title: 'Закриті звернення'
    end
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

  def status_inspector
    redirect_back(fallback_location: root_path) unless
      %w(opened closed).include?(params[:status])
  end
end
