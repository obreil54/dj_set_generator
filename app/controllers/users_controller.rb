class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    redirect_to root_path, alert: "Access denied." unless @user == current_user
  end

  def edit_avatar
    @user = current_user
    render partial: "users/avatar_form", locals: { user: @user }
  end

  def update_avatar
    @user = current_user
    if @user.update(user_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to user_path(@user), notice: "Avatar updated successfully" }
      end
    else
      render partial: "users/avatar_form", status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:profile_picture)
  end
end
