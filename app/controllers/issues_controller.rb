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
    category_id = @issue.category_id
    @relevant_issues = find_relevant(category_id, @issue.id).limit(4)
    redirect_back(fallback_location: root_path) unless \
                                                @issue.can_read?(current_user)
    status = @issue.status
    @issue_label = issue_status(status)
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

  def find_relevant(category_id, issue_id)
    Issue.where(category_id: category_id)
         .where.not(id: issue_id)
  end

  def issue_status(status)
    case status
    when 'open'     then 'label-success'
    when 'pending'  then 'label-warning'
    when 'declined' then 'label-danger'
    when 'closed'   then 'label-default'
    end
  end
end
