# Encoding: utf-8
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
          flash[:success] = 'Звернення змінено!'
          facebook_posting(@issue) if @issue.status == 'open'
          redirect_to @issue
        else
          render 'edit'
        end
      end

      def approve
        @issue.update_attribute('status', :open)
        facebook_posting(@issue)
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

      def facebook_posting(issue)
        return if Rails.env.test?
        page = prepare_facebook_page
        page.feed!(message: issue.fb_message,
                   link: issue_url(issue), name: issue.title.to_s,
                   picture: issue.fb_picture)
      end

      def prepare_facebook_page
        FbGraph2::Page.new(ENV['FACEBOOK_GROUP_ID'],
                           access_token: ENV['FACEBOOK_GROUP_TOKEN'])
      end

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
