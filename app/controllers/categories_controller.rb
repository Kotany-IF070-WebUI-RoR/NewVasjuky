# frozen_string_literal: true
class CategoriesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user,
                     only: [:show]
  def show
    @category = Category.find(params[:id])
    set_meta_tags title: @category.name,
                  description: @category.description
    issues_scope = @category.issues.approved.ordered
    issues_scope = issues_scope.like(params[:filter]) if params[:filter]
    smart_listing_create :issues,
                         issues_scope,
                         partial: 'issues/issue'
    @categories = Category.ordered_by_name
  end
end
