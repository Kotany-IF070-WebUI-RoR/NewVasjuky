# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@newvasjuky.com'
  layout 'mailer'
end
