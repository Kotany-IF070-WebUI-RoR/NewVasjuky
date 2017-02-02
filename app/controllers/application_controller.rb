# Encoding: utf-8
# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper_method :admin?, :admin_or_moderator?
  include SmartListing::Helper::ControllerExtensions
  helper  SmartListing::Helper
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :require_active_user,
                if: -> { user_signed_in? && !devise_controller? }

  after_action :prepare_unobtrusive_flash

  def require_active_user
    return unless current_user.banned?
    redirect_back(fallback_location: root_path)
    flash[:alert] = 'У вас немає доступу доступу цієї сторінки.
                     Ваш аккаунт заблоковано.'
  end

  def current_user
    @current_user ||= super || User.new
  end

  def user_signed_in?
    current_user.persisted?
  end
end
