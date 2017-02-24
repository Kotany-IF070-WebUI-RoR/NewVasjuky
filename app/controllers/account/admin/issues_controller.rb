# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      before_action :admin_or_moderator?
      skip_before_action :admin_or_moderator?, only: [:close]
      before_action :find_issue,
                    only: [:edit, :update, :approve, :close, :decline]
      before_action :build_event,
                    only: [:approve, :close, :decline]
      before_action :can_close?, only: [:close]
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
        if @issue.may_approve?
          @issue.approve!
          @issue.create_event(@event)
          @issue.post_to_facebook!
          redirect_to @issue, notice: 'Статус успішно змінений.'
        else
          redirect_to @issue, error: 'Щось пішло не так, спробуйте ще раз...'
        end
      end

      def decline
        if @issue.may_decline?
          @issue.decline!
          @issue.create_event(@event)
          redirect_to @issue, notice: 'Статус успішно змінений.'
        else
          redirect_to @issue, error: 'Щось пішло не так, спробуйте ще раз...'
        end
      end

      def close
        if @issue.may_close?
          @issue.close!
          @issue.create_event(@event)
          redirect_to @issue, notice: 'Статус успішно змінений.'
        else
          redirect_to @issue, error: 'Щось пішло не так, спробуйте ще раз...'
        end
      end

      private

      def find_issue
        @issue = Issue.find(params[:id])
      end

      def issues_params
        params.require(:issue).permit(:category_id, :location, :latitude,
                                      :longitude)
      end

      def build_event
        @event = Event.new(event_params)
        @event.issue = @issue
        @event.author_id = current_user.id
      end

      def event_params
        params.require(:event).permit(:description, :image)
      end

      def can_close?
        redirect_to @issue, notice: 'Ви не маєте права на це...' \
                                          unless current_user.can_close?(@issue)
      end
    end
  end
end
