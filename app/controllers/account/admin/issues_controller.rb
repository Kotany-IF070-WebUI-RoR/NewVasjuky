# Encoding: utf-8
# frozen_string_literal: true
module Account
  module Admin
    class IssuesController < ApplicationController
      before_action :admin_or_moderator?
      before_action :find_issue,
                    only: [:edit, :update, :approve, :close, :decline]
      skip_before_action :admin_or_moderator?, only: [:close]
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
        if change_status_transaction(@issue, 'approve', event_params)
          @issue.post_to_facebook!
          redirect_to @issue, notice: 'Статус успішно змінений.'
        else
          redirect_to @issue, notice: 'Щось пішло не так, спробуйте ще раз...'
        end
      end

      def decline
        if change_status_transaction(@issue, 'decline', event_params)
          redirect_to @issue, notice: 'Статус успішно змінений.'
        else
          redirect_to @issue, notice: 'Щось пішло не так, спробуйте ще раз...'
        end
      end

      def close
        if change_status_transaction(@issue, 'close', event_params)
          redirect_to @issue, notice: 'Статус успішно змінений.'
        else
          redirect_to @issue, notice: 'Щось пішло не так, спробуйте ще раз...'
        end
      end

      private

      def change_status_transaction(issue, status, event_params)
        ActiveRecord::Base.transaction do
          issue.send("#{status}!")
          @event = build_event(issue, event_params)
          @event.save!
        end
      rescue ActiveRecord::RecordInvalid, AASM::InvalidTransition
        false
      end

      def build_event(issue, event_params)
        event = Event.new(event_params)
        event.issue = issue
        event.author_id = current_user.id
        event.before_status = issue.aasm.from_state
        event.after_status = issue.aasm.to_state
        event
      end

      def can_close?
        redirect_to @issue, error: 'Щось пішло не так, спробуйте ще раз...'\
                                          unless current_user.can_close?(@issue)
      end

      def find_issue
        @issue = Issue.find(params[:id])
      end

      def issues_params
        params.require(:issue).permit(:category_id, :location, :latitude,
                                      :longitude)
      end

      def event_params
        params.require(:event).permit(:description, :image)
      end
    end
  end
end
