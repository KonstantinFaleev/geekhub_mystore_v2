require 'test_helper'

class UserStoriesTest < ActionDispatch::IntegrationTest
  fixtures :products
  include ActiveJob::TestHelper
# A user goes to the index page. They select a product, adding it to their
# cart, and check out, filling in their details on the checkout form. When
# they submit, an order is created containing their information, along with a
# single line item corresponding to the product they added to their cart.
  test "buying a product" do
    start_order_count = Order.count
    ruby_book = products(:ruby)
    get "/"
    assert_response :success
    assert_select 'h1', "Your Catalog"
    post '/line_items', params: { product_id: ruby_book.id }, xhr: true
    assert_response :success
    cart = Cart.find(session[:cart_id])
    assert_equal 1, cart.line_items.size
    assert_equal ruby_book, cart.line_items[0].product
    get "/orders/new"
    assert_response :success
    assert_select 'legend', 'Please Enter Your Details'
    perform_enqueued_jobs do
      post "/orders", params: {
          order: {
              name: "Dave Thomas",
              phone: "123456789",
              email: "dave@example.com",
          }
      }
      follow_redirect!
      assert_response :success
      assert_select 'h1', "Your Catalog"
      cart = Cart.find(session[:cart_id])
      assert_equal 0, cart.line_items.size
      assert_equal start_order_count + 1, Order.count
      order = Order.last
      assert_equal "Dave Thomas", order.name
      assert_equal "123456789", order.phone
      assert_equal "dave@example.com", order.email
      assert_equal 1, order.line_items.size
      line_item = order.line_items[0]
      assert_equal ruby_book, line_item.product
      mail = ActionMailer::Base.deliveries.last
      assert_equal ["dave@example.com"], mail.to
      assert_equal 'Konstantin Faleev <store@example.com>', mail[:from].value
      assert_equal "GeekHub My Store Order Confirmation", mail.subject
      end
  end
end
