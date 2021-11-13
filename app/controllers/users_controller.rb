class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def new
    @user = User.new
  end

  def show
    @user = User.find_by id: params[:id]
    return if @user.present?

    flash[:danger] = t "flash.danger"
    redirect_to root_path
  end

  def create
    @user = User.new user_params
    if @user.save
      log_in @user
      flash[:success] = t "flash.success"
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
  end

  def update
    @user = User.find_by(id: params[:id])
    if @user.update(user_params)
      flash[:success] = t "flash.profile_updated"
      redirect_to @user
    else
      render "edit"
    end
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def destroy
    @user = User.find_by(id: params[:id])
    if @user&.destroy
      flash[:success] = t "flash.user_deleted"
    else
      flash[:danger] = t "flash.delete_fail"
    end
    redirect_to users_url
  end

  private

  def user_params
    params
      .require(:user).permit :name, :email, :password, :password_confirmation
  end

  # before filters
  # confirms a logged-in user
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "flash.please_login"
      redirect_to login_url
    end
  end

  # confirms the correct user
  def correct_user
    @user = User.find_by(id: params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end

  # confirms an admin user
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
