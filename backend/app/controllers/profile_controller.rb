class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_profile_complete, only: [:show]

  def show
    @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
  end

  private

  def ensure_profile_complete
    return if current_user.profile_complete?
  end
end
