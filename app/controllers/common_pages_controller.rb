# Encoding: utf-8
# frozen_string_literal: true
class CommonPagesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user, only: [:home]

  def home
    set_meta_tags title: 'Корисні посилання'
    @issues_feed = Issue.approved.ordered.limit(4)
    @count = Issue.approved.count
    @closed_count = Issue.closed.count
  end
end
