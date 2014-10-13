class ErrorNotifier < ActionMailer::Base
  default from: "PragmaticStore@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.error_notifier.error_alert.subject
  #
  def error_alert(e)
    @e = e

    mail to: "admin@example.com", subject: "Pragmatic Store Error Notification"
  end
end
