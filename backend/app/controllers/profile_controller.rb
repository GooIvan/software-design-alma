class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
  end
end
