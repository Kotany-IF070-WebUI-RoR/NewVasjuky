# frozen_string_literal: true
class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index]

  def index
    @issues = Issue.approved.ordered
    @issues_feed = @issues.first(4)
    @count = Issue.all.count
    @approved_count = @issues.count
  end
end
