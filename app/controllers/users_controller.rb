# Encoding: utf-8
class UsersController < ApplicationController
  before_action :find_user, only: [:show]
  skip_before_action :require_active_user, only: [:show, :ranking]
  skip_before_action :authenticate_user!, only: [:ranking]

  def show
    set_meta_tags title: 'Мої звернення'
    issue_listing(@user.issues)
  end

  def ranking
    set_meta_tags title: 'Рейтинг активності користувачів',
                  description: 'На даній сторінці ви можете ознайомитись
                              з рейтингом користувачів за певний період'
    @period = params[:period] || 30
    @period = @period.to_i if [7, 30, 90].include?(@period.to_i)
    @users = User.top_ranking_for(@period)
    @categories = Category.ordered_by_name
  end

  private

  def find_user
    @user = User.find(params[:id])
  end
end
