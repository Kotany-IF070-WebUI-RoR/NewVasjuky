class PagesController < ApplicationController
  skip_before_action :authenticate_user!, :require_active_user, only: [:show]
  def show
    if valid_page?
      render template: "pages/#{params[:page]}"
    else
      render file: 'public/404.html', status: :not_found
    end
  end

  private

  def valid_page?
    @template = "app/views/pages/#{params[:page]}.html.slim"
    File.exist?(Pathname.new(Rails.root + @template))
  end
end
