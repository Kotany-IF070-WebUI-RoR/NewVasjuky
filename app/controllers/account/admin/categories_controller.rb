# Encoding: utf-8
module Account
  module Admin
    class CategoriesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :status_inspector, only: [:issues]
      before_action :find_category,
                    only: [:edit, :update, :issues]

      def index
        @categories = Category.all
        smart_listing_create :categories, @categories,
                             sort_attributes: [
                               [:created_at, 'categories.created_at'],
                               [:updated_at, 'categories.updated_at'],
                               [:name, 'categories.name'],
                               [:calculate, 'categories.issues_count']
                             ],
                             default_sort: { name: 'asc' }, partial: 'category'
      end

      def new
        @category = Category.new
      end

      def create
        @category = Category.new(category_params)
        if @category.save
          flash[:success] = 'Категорію створено!'
          redirect_to account_admin_categories_path
        else
          render 'new'
        end
      end

      def edit; end

      def update
        if @category.update_attributes(category_params)
          flash[:success] = 'Категорію відредаговано!'
          redirect_to account_admin_categories_path
        else
          render 'edit'
        end
      end

      def issues
        @status = params[:status] || 'opened'
        issues_scope = @category.issues.ordered
                                .where(status: @status)
        issues_scope = issues_scope.like(params[:filter]) if params[:filter]
        smart_listing_create :issues,
                             issues_scope,
                             partial: 'issues/issue'
        @categories = Category.ordered_by_name
        render 'issues/index'
      end

      private

      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :tags)
      end

      def status_inspector
        redirect_to issues_account_admin_category_path(status: 'opened') unless
          %w(opened closed pending declined).include?(params[:status])
      end
    end
  end
end
