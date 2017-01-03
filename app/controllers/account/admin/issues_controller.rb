# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      before_action :admin_or_moderator?
      def index
        @issues = Issue.ordered.page(params[:page]).per(20)
      end

      def approve
        @issue = Issue.find(params[:id])
        @issue.update_attribute('approved', 'true')
        redirect_to request.referrer
      end

      def destroy
        @issue = Issue.find(params[:id])
        @issue.destroy
        redirect_to request.referrer
      end
    end
  end
end
