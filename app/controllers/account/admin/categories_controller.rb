# Encoding: utf-8
module Account
  module Admin
    class CategoriesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :find_category,
                    only: [:edit, :update, :calculate]

      def index
        @categories = Category.all.ordered_by_name
      end

      def new
        @category = Category.new
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

      private

      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, :description, :tags)
      end
    end
  end
end
