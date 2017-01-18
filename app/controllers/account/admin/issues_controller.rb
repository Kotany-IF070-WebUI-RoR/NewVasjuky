# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :find_issue,
                    only: [:edit, :update, :approve, :destroy, :decline]
      def index
        @issues = Issue.ordered.page(params[:page]).per(20)
      end

      def edit; end

      def update
        if @issue.update_attributes(issues_params)
          flash[:success] = 'Issue updated'
          redirect_to @issue
        else
          render 'edit'
        end
      end

      def approve
        @issue.update_attribute('status', :open)
        redirect_back(fallback_location: root_path)
      end

      def decline
        @issue.update_attribute('status', :declined)
        redirect_back(fallback_location: root_path)
      end

      def destroy
        @issue.destroy
        redirect_back(fallback_location: root_path)
      end

      private

      def find_issue
        @issue = Issue.find(params[:id])
      end

      def issues_params
        params.require(:issue).permit(:category_id, :location, :approved,
                                      :latitude, :longitude, :status)
      end
    end
  end
end
