class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = User.find(params[:id])
    redirect_to root_path, alert: "Access denied." unless @user == current_user
  end

  def edit_avatar
    @user = current_user
    render partial: "users/avatar_form", locals: {user: @user}
  end

  def update_avatar
    @user = current_user

    if params[:user].blank? || params[:user][:profile_picture].blank?
      @user.errors.add(:profile_picture, "Please select an image before updating")
      return render turbo_stream: turbo_stream.replace("avatar_form", partial: "users/avatar_form", locals: {user: @user}), status: :unprocessable_entity
    end

    if @user.update(user_params)
      respond_to do |format|
        format.turbo_stream
      end
    else
      respond_to do |format|
        render turbo_stream: turbo_stream.replace("avatar_form", partial: "users/avatar_form", locals: {user: @user}), status: :unprocessable_entity
      end
    end
  end

  private

  def user_params
    params.fetch(:user, {}).permit(:profile_picture)
  end
end
