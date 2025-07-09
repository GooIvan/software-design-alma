class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :check_admin_role

  def index
    @home_video = HomeVideo.first_or_initialize
    @users = User.all
    @orders = Order.all
    @category = Category.all

    @labels = (1..12).map { |m| Date::MONTHNAMES[m] }
    year = Date.current.year.to_s

    @usuarios_por_mes = (1..12).map do |month|
      month_str = month.to_s.rjust(2, '0') # '01', '02', ..., '12'
      User.where("strftime('%Y', created_at) = ? AND strftime('%m', created_at) = ?", year, month_str).count
    end

    @ordenes_pagadas_por_mes = (1..12).map do |month|
      month_str = month.to_s.rjust(2, '0')
      Order.where(status: "paid")
          .where("strftime('%Y', created_at) = ? AND strftime('%m', created_at) = ?", year, month_str)
          .count
    end
  end

  def update_home_video
    @home_video = HomeVideo.first_or_initialize
    if @home_video.update(home_video_params)
      redirect_to admin_dashboard_path, notice: "Video actualizado con éxito"
    else
      redirect_to admin_dashboard_path, alert: "Error al actualizar el video"
    end
  end

  private

  def home_video_params
    params.require(:home_video).permit(:title, :video, :file_video, :slogan, :text_color)
  end

  def check_admin_role
    redirect_to root_path, alert: "No tienes permisos de administrador" unless current_user.admin?
  end
end
