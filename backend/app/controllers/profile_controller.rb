class ProfileController < ApplicationController
  before_action :authenticate_user!

  def show
    @orders = current_user.orders.includes(order_items: :product).order(created_at: :desc)
  end

  def edit
    @user = current_user
  end

def update
  @user = current_user
  if @user.update(user_params)
    redirect_to profile_path
  else
    puts @user.errors.full_messages  # <- esto te dice qué está fallando
    render :edit, status: :unprocessable_entity
  end
end


  private

  def profile_params
    params.require(:user).permit(:name, :last_name, :phone, :address, :city)
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :phone, :address, :city)
  end
end
