# Encoding: utf-8
module Account
  module Admin
    class CategoriesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :status_inspector, only: [:show]
      before_action :find_category, except: [:index, :create, :new]

      def index
        category_listing(Category.all)
      end

      def show
        @status = params[:status] || 'opened'
        smart_listing_create :issues,
                             @category.issues_list(@status, params[:filter]),
                             partial: 'issues/issue'
        @categories = Category.ordered_by_name
        render 'issues/index'
      end

      def new
        @category = Category.new
      end

      def create
        @category = Category.new(category_params)
        if @category.save
          redirect_to_index flash: { success: 'Категорію створено!' }
        else
          render 'new'
        end
      end

      def edit; end

      def update
        @category.assign_attributes(category_params)
        flash[:notice] = 'Ви не внесли жодних змін' unless @category.changed?
        if @category.save
          redirect_to_index flash: { success: 'Категорію відредаговано!' }
        else
          render 'edit'
        end
      end

      def destroy
        if @category.issues.empty?
          @category.destroy
          redirect_to_index flash: { success: 'Категорію видалено!' },
                            status: 303
        else
          redirect_to_index flash: { alert: 'Неможливо видалити непусту
                                             категорію! Спочатку Вам
                                             необхідно перемістити з неї
                                             всі скарги.' }
        end
      end

      private

      def redirect_to_index(parameters)
        redirect_to account_admin_categories_path, parameters
      end

      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :tags)
      end

      def status_inspector
        value = %w(opened closed pending declined).include?(params[:status])
        redirect_to account_admin_category_path(status: 'opened') unless value
      end

      def smart_listing_config_profile
        :category_profile
      end
      helper_method :smart_listing_config_profile
    end
  end
end
