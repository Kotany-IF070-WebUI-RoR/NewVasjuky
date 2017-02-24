# Encoding: utf-8
module Account
  module Admin
    class CategoriesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :status_inspector, only: [:show]
      before_action :find_category, except: [:index, :create, :new]

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

      def create
        @category = Category.new(category_params)
        if @category.save
          flash[:success] = 'Категорію створено!'
          redirect_to account_admin_categories_path
        else
          render 'new'
        end
      end

      def new
        @category = Category.new
      end

      def edit; end

      def show
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

      def update
        if @category.update_attributes(category_params)
          flash[:success] = 'Категорію відредаговано!'
          redirect_to account_admin_categories_path
        else
          render 'edit'
        end
      end

      def destroy
        if @category.issues.empty?
          @category.destroy
          flash[:success] = 'Категорію видалено!'
          redirect_to action: 'index', status: 303
        else
          flash[:alert] = 'Неможливо видалити непусту категорію!
                           Спочатку Вам необхідно перемістити з неї
                           всі скарги.'
        end
      end

      private

      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :tags)
      end

      def status_inspector
        redirect_to account_admin_category_path(status: 'opened') unless
          %w(opened closed pending declined).include?(params[:status])
      end

      def smart_listing_config_profile
        :category_profile
      end
      helper_method :smart_listing_config_profile
    end
  end
end
