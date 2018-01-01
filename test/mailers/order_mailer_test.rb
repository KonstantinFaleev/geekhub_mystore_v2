require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received
    assert_equal "GeekHub My Store Order Confirmation", mail.subject
    assert_equal ["konstantin@example.com"], mail.to
    assert_equal ["store@example.com"], mail.from
    assert_match /Велосипед Cyclone FRC 75 28" рама 19"/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped
    assert_equal "GeekHub My Store Order Shipped", mail.subject
    assert_equal ["konstantin@example.com"], mail.to
    assert_equal ["store@example.com"], mail.from
    assert_match /<td>1&times;<\/td>\s*<td>Велосипед Cyclone FRC 75 28" рама 19"<\/td>/, mail.body.encoded
  end

end
