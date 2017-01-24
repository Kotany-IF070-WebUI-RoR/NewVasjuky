# Encoding: utf-8
class IssuesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:index, :show]
  def index
    @issues = Issue.approved.ordered.page(params[:page]).per(10)
  end

  def new
    @issue = current_user.issues.new
    @categories = Category.by_name
  end

  def show
    @issue = Issue.find(params[:id])
    @relevant_issues = @issue.category.issues.where.not(id: @issue.id)
                             .order('random()').limit(4)
    redirect_back(fallback_location: root_path) unless \
                                                @issue.can_read?(current_user)
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
end
