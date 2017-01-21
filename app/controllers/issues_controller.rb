# Encoding: utf-8
class IssuesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:index, :show]
  def index
    @issues = Issue.approved.ordered.page(params[:page]).per(10)
  end

  def map
    @issues = Issue.all
  end

  def new
    @issue = Issue.new
  end

  def show
    @issue = Issue.find(params[:id])
    redirect_back(fallback_location: root_path) unless \
                                                  @issue.can_read?(current_user)
  end

  def create
    @issue = Issue.new(issues_params)
    @issue.user_id = current_user.id
    if @issue.save
      redirect_to root_path, notice: 'Звернення створене успішно!'
    else
      render 'new'
    end
  end

  private

  def issues_params
    params.require(:issue).permit(:name, :address, :phone, :email,
                                  :category_id, :description, :attachment,
                                  :location, :title)
  end
end
