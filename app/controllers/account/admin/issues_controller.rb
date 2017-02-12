# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :find_issue,
                    only: [:edit, :update, :approve, :close, :decline]
      def index
        issue_listing(Issue.moderation_list)
      end

      def edit; end

      def update
        if @issue.update_attributes(issues_params)
          flash[:success] = 'Звернення змінено!'
          @issue.post_to_facebook! if @issue.opened?
          redirect_to @issue
        else
          render 'edit'
        end
      end

      def approve
        @issue.create_event_by(current_user) if @issue.approve!
        @issue.post_to_facebook!
        render :update, issue: @issue
      end

      def decline
        @issue.create_event_by(current_user) if @issue.decline!
        render :update, issue: @issue
      end

      def close
        @issue.create_event_by(current_user) if @issue.close!
        render :update, issue: @issue
      end

      private

      def find_issue
        @issue = Issue.find(params[:id])
      end

      def issues_params
        params.require(:issue).permit(:category_id, :location, :latitude,
                                      :longitude)
      end
    end
  end
end
