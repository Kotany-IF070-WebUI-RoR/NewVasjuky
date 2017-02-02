# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :find_issue,
                    only: [:edit, :update, :approve, :destroy, :decline]
      def index
        issue_listing(Issue.all)
      end

      def edit; end

      def update
        if @issue.update_attributes(issues_params)
          flash[:success] = 'Звернення змінено!'
          @issue.post_to_facebook! if @issue.open?
          redirect_to @issue
        else
          render 'edit'
        end
      end

      def approve
        @issue.update_attribute('status', :open)
        @issue.post_to_facebook!
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
        params.require(:issue).permit(:category_id, :location, :latitude,
                                      :longitude, :status)
      end
    end
  end
end
