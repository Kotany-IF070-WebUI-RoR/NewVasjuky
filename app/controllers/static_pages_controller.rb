class StaticPagesController < ApplicationController
  def map
    @issues = Issue.all
  end
end
