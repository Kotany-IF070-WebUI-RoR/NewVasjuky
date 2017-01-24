# frozen_string_literal: true
class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:show]
  def show
    @category = Category.find(params[:id])
    @issues = @category.issues.approved.ordered.page(params[:page]).per(10)
  end
end
