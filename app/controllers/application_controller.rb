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
  before_action :prepare_meta_tags,
                if: 'request.get?'

  after_action :prepare_unobtrusive_flash

  def prepare_meta_tags(options = {})
    site_name   = 'NewVasjuky'
    title       = 'Помічник у вирішенні комунальних проблем'
    description = 'З допомогою цього додатка можна у кілька кліків надіслати
                  звернення для вирішення різноманітних комунальних проблем'
    image       = options[:image] || '/images/if.jpg'
    current_url = request.url
    defaults = { site: site_name, title: title, image: image,
                 description: description,
                 keywords: %w(Івано-Франківськ Ivano-Frankivsk),
                 og: { url: current_url, site_name: site_name, title: title,
                       image: image, description: description,
                       type: 'website' } }
    options.reverse_merge!(defaults)
    set_meta_tags options
  end

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
