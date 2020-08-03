class UsersController < ApplicationController

  layout 'user'

  before_action :authenticate

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])

    unless @user == current_user
      redirect_to user_path(@user)
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(creat_params)
      flash[:notice] = "更新に成功しました。"
      redirect_to @user
    else
      render "edit"
    end
  end

  private

    def set_user
      @user = User.find(params[:id])
    end

    def creat_params
      params.require(:user).permit(:name, :gender, :university, :comment, :twitter, :instagram, :other_link, :image)
    end

    def authenticate
      unless user_signed_in?
        flash[:error] = "ログインが必要です。"
        redirect_to new_user_session_path
      end
    end
end
