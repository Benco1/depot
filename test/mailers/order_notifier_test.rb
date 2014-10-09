require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  
  test "received" do
    mail = OrderNotifier.received(orders(:one))
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal ["bobbylee@example.com"], mail.to
    assert_equal ["PragmaticStore@example.com"], mail.from
    assert_match /Thank you for your recent order from The Pragmatic store./,
      mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:one))
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal ["bobbylee@example.com"], mail.to
    assert_equal ["PragmaticStore@example.com"], mail.from
    assert_match /This is just to let you know that we've shipped your recent order:/,
      mail.body.encoded
  end

end
