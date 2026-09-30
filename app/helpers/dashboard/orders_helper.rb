# app/helpers/dashboard/orders_helper.rb
module Dashboard::OrdersHelper
  def order_status_color(status)
    case status
    when 'pending'
      'yellow'
    when 'processing'
      'blue'
    when 'shipped'
      'indigo'
    when 'delivered'
      'green'
    when 'cancelled'
      'red'
    else
      'gray'
    end
  end
end