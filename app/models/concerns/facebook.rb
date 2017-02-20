# Encoding: utf-8
module Facebook
  extend ActiveSupport::Concern
  included do
    def fb_post
      { message: fb_message, link: fb_link,
        name: title.to_s, picture: fb_picture }
    end

    def fb_message
      fb_location = location.blank? ? '' : "Адреса: #{location} \n \n"
      fb_description = description.blank? ? '' : "Опис: #{description} \n \n"
      tags = ('#' + category.tags).to_s.gsub(' ', ' #')
      [fb_location, fb_description, tags].reject(&:blank?).join(' ')
    end

    def fb_link
      issue_url(self, host: Rails.application.config.host)
    end

    def fb_picture
      picture = first_attached_image.path || 'uploads/default-image.jpg'
      "#{ENV['IMAGE_HOSTING_URL']}#{picture}"
    end

    def post_to_facebook!
      return if !Rails.env.production? || posted_on_facebook?
      page = prepare_facebook_page
      page.feed!(fb_post)
      update_attribute('posted_on_facebook', true)
    end
  end
end
