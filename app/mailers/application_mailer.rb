# frozen_string_literal: true

# The ApplicationMailer class is the base class for all mailers in the application.
# It inherits from ActionMailer::Base and provides common functionality for sending emails.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
