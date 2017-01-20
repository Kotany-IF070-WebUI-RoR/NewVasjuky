# frozen_string_literal: true
class ApplicationMailer < ActionMailer::Base
  default from: 'new_issue@newvasjuky.com'
  layout 'mailer'
end
