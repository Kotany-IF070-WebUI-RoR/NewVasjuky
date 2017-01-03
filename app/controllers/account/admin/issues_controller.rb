# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      def index
        @issues = Issue.ordered.page(params[:page]).per(20)
        authorize @issues
      end

      def approve
        @issue = Issue.find(params[:id])
        authorize @issue
        @issue.update_attribute('approved', 'true')
        redirect_to request.referrer
      end

      def destroy
        @issue = Issue.find(params[:id])
        authorize @issue
        @issue.destroy
        redirect_to request.referrer
      end
    end
  end
end
