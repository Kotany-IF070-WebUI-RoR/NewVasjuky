# frozen_string_literal: true
require_relative 'boot'

require 'rails/all'
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module NewVasjuky
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified
    # here.
    config.i18n.default_locale = :uk
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
