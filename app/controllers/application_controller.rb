# Encoding: utf-8
# frozen_string_literal: true
class ApplicationController < ActionController::Base
  include ApplicationHelper
  helper_method :admin?, :admin_or_moderator?
  protect_from_forgery with: :exception

  before_action :authenticate_user!, :banned?

  after_action :prepare_unobtrusive_flash

  def banned?
    return unless user_signed_in? && current_user.banned?
    sign_out current_user
    flash[:notice] = nil
    flash.now[:alert] = 'Цей аккаунт був заблокований!'
    root_path
  end

  def current_user
    @current_user ||= super || User.new
  end
end
