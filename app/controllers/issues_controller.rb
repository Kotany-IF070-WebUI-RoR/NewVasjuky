class IssuesController < ApplicationController
  def new
    @issue = Issue.new
    authorize(@issue)
  end

  def create
    @issue = Issue.new(issues_params)
    authorize(@issue)
    @issue.user_id = current_user.id
    if @issue.save
      redirect_to root_path, notice: 'Assignment successfully created!'
    else
      render 'new'
    end
  end

  private

  def issues_params
    params.require(:issue).permit(:name, :address, :phone, :email,
                                  :category, :description, :attachment)
  end
end