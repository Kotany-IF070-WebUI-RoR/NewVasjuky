# Encoding: utf-8
class IssuesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :setup_issue, only: [:create]
  def new
    @issue = Issue.new
    @issue_attachment = @issue.issue_attachments.build
  end

  def index
    @issues = Issue.approved.ordered.page(params[:page]).per(10)
  end

  def create
    respond_to do |format|
      if @issue.save
        create_attachments(params[:issue_attachments][:attachment])
        format.html do
          redirect_to root_path, notice: 'Звернення створене успішно!'
        end
      else
        format.html { render 'new' }
      end
    end
  end

  def show
    @issue = Issue.find(params[:id])
  end

  private

  def issues_params
    params.require(:issue).permit(:name, :address, :phone, :email,
                                  :category_id, :description,
                                  :location, :title,
                                  issue_attachments: [])
  end

  def setup_issue
    @issue = Issue.new(issues_params)
    @issue.user_id = current_user.id
  end

  def create_attachments(attachments)
    attachments.each do |a|
      @issue_attachment = @issue.issue_attachments.create!(
        attachment: a
      )
    end
  end
end
