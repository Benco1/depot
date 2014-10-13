require 'test_helper'

class ErrorNotifierTest < ActionMailer::TestCase
  test "error_alert" do
    mail = ErrorNotifier.error_alert
    assert_equal "Error alert", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
