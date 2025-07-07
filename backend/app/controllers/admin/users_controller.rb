class Admin::UsersController < ApplicationController
  layout "admin"
  before_action :authenticate_user!
  before_action :check_admin_role
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]  # Cargar el usuario antes de las acciones

  def index
    @cities = User.distinct.pluck(:city).compact.sort  # Obtener todas las ciudades
    @users = User.all
    if params[:city].present? && params[:city] != "Todas"
      @users = @users.where(city: params[:city])
    end

    if params[:name].present?
      @users = @users.where("LOWER(name) LIKE :query OR LOWER(last_name) LIKE :query", query: "%#{params[:name].downcase}%")
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to admin_users_path, notice: "Usuario creado exitosamente."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # @user ya está cargado
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "Usuario actualizado correctamente."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    redirect_to admin_users_path, notice: "Usuario eliminado correctamente."
  end

  def bulk_delete
    User.where(id: params[:selected_users]).destroy_all
    redirect_to admin_users_path, notice: "Usuarios eliminados correctamente."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :last_name, :city, :address, :email, :password, :password_confirmation, :role)
  end

  def check_admin_role
    redirect_to root_path, alert: "No tienes permisos de administrador" unless current_user.admin?
  end
end
